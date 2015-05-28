#Xavier Hduon-Dansereau
#05/05/2015
#Script #1
#Lancer à partir du serveur Réel
#Ce code modifie les configurations du serveur Réel
#------------------------------------------------------
#Déclaration
#------------
$reelName = "Externe";
$v1Name = "InterneUn";
$v2Name = "InterneDeux";
$v3Name = "Routeur";

$carteReelNom = (Get-NetAdapter -InterfaceDescription "Connexion Ethernet Intel(R) I217-LM").Name;
$carteExterneNom = "WAN";
$carteInterneNom = "CEGAT";

#-------------
#Script
#-------------

try{
    if(! (Get-WindowsFeature -Name hyper-v)){
        installHyperV;
        renameComputer;
        restartComputer;
    }
    else{
        "Hyper-V est déjà installé, voici la suite : "
        setExternalCard;
        addVirtualSwitch;
        creerVM;
        addAdapter $v1Name;
        addAdapter $v2Name;
        addAdapter $v3Name;
        enableNumLock $v1Name;
        enableNumLock $v2Name;
        enableNumLock $v3Name;
        showExtention;
        disableAutoUpdate;
        disable_IE_IntrusiveSecurity;
        enableBureauDistance;
    }
}catch{
    echo "Ça a merdé : "
    echo $_.Exception.GetType().FullName
    echo $_.Exception.Message
}






function installHyperV{
    Write-Host "Installation de hyper-v" -ForegroundColor Green
    
    Install-WindowsFeature -Name Hyper-v -IncludeAllSubFeature -IncludeManagementTools
    Install-WindowsFeature -Name RSAT-Hyper-V-Tools -IncludeAllSubFeature -IncludeManagementTools
}

function renameComputer{
    Write-Host "Changement du nom du PC" -ForegroundColor Green
    Rename-Computer -NewName Externe
}

function restartComputer{
    Write-Host "Redémarage du PC dans 5 secondes, pèse sur 'CTRL+C' pour annuler" -ForegroundColor Red -BackgroundColor Black
    Start-Sleep -s 5
    Restart-Computer -Force
}

function setExternalCard{
    #"Retrait de l'ancienne adresse IP"
    #Remove-NetIPAddress -IPAddress (Get-NetIPAddress -InterfaceAlias $adapter.Name).IPv4Address

    Write-Host "Ajout d'une nouvelle adresse IP" -ForegroundColor Green
    
    new-NetIPAddress -InterfaceAlias $carteReelNom -IPAddress 10.57.64.23 -PrefixLength 16 -AddressFamily IPV4 -DefaultGateway 10.57.1.1

    Write-Host "Ajout des parametres de DNS" -ForegroundColor Green
    
    Set-DnsClientServerAddress -InterfaceAlias $carteReelNom -ServerAddresses ("10.57.4.28","10.57.4.29")
}

function addVirtualSwitch{
    Write-Host "Suppression des anciennes cartes virtuels" -ForegroundColor Green
    Remove-VMSwitch -VMSwitch (Get-VMSwitch) -Force

    Write-Host "Ajout de la carte virtuel externe" -ForegroundColor Green
    New-VMSwitch -Name $carteExterneNom -NetAdapterName $carteReelNom

    
    Write-Host "Ajout de la carte virtuel interne" -ForegroundColor Green
    New-VMSwitch -SwitchType Internal -Name $carteInterneNom
}

function creerVM{
    Write-Host "Creation des Machines Virtuels" -ForegroundColor Green
    Remove-VM -Name $v1Name -Force
    Remove-VM -Name $v2Name -Force
    Remove-VM -Name $v3Name -Force

    New-VM -Name $v1Name -MemoryStartupBytes 4096mb -VHDPath c:\_VirDisque\S1_PROJET.vhdx -Path c:/_VirOrdi
    New-VM -Name $v2Name -MemoryStartupBytes 4096mb -VHDPath c:\_VirDisque\S2_PROJET.vhdx -Path c:/_VirOrdi
    New-VM -Name $v3Name -MemoryStartupBytes 512mb -VHDPath c:\_VirDisque\Routeur_Projet.vhd -Path c:/_VirOrdi
}

function addAdapter($VMnom){
    Write-Host "Ajout de l'Adaptateur" -ForegroundColor Green
    
    Add-VMNetworkAdapter -VMName $VMnom -Name "AdapterInterne" -IsLegacy $true
}

function enableNumLock($VMnom){
    Write-Host "Ajout des num lock au startup" -ForegroundColor Green
    
    Set-VMBios -VMName $VMnom -EnableNumLock
}

function showExtention{
    Write-Host "Affichage des extentions" -ForegroundColor Green
    
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $key Hidden 1
    Set-ItemProperty $key HideFileExt 0
    Set-ItemProperty $key ShowSuperHidden 1
    Stop-Process -processname explorer
    Start-Process Explorer.exe
}

function disableAutoUpdate{
    "Désactivation des updates automatiques"
    #https://social.technet.microsoft.com/Forums/windowsserver/en-US/abde2699-0d5a-49ad-bfda-e87d903dd865/disable-windows-update-via-powershell?forum=winserverpowershell
        $_ = "localhost"
        $service = Get-WmiObject Win32_Service -Filter 'Name="wuauserv"' -Ea 0
	    if ($service)
	    {
		    if ($service.StartMode -ne "Disabled")
		    {
			    $result = $service.ChangeStartMode("Disabled").ReturnValue
			    if($result)
			    {
				    "Failed to disable the 'wuauserv' service on $_. The return value was $result."
			    }
			    else {"Success to disable the 'wuauserv' service on $_."}
			
			    if ($service.State -eq "Running")
			    {
				    $result = $service.StopService().ReturnValue
				    if ($result)
				    {
					    "Failed to stop the 'wuauserv' service on $_. The return value was $result."
				    }
				    else {"Success to stop the 'wuauserv' service on $_."}
			    }
		    }
		    else {"The 'wuauserv' service on $_ is already disabled."}
	    }
	    else {"Failed to retrieve the service 'wuauserv' from $_."}
}

function disable_IE_IntrusiveSecurity{
    "Désactivation de la sécurité intrusive explorer"
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer.exe
    Start-Process Explorer.exe
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

function enableBureauDistance{
#http://networkerslog.blogspot.ca/2013/09/how-to-enable-remote-desktop-remotely.html
    set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Bureau à distance"
    set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1  
}

function pinToTaskBar{
#--------------------------------------------------------------------------------- 
#The sample scripts are not supported under any Microsoft standard support 
#program or service. The sample scripts are provided AS IS without warranty  
#of any kind. Microsoft further disclaims all implied warranties including,  
#without limitation, any implied warranties of merchantability or of fitness for 
#a particular purpose. The entire risk arising out of the use or performance of  
#the sample scripts and documentation remains with you. In no event shall 
#Microsoft, its authors, or anyone else involved in the creation, production, or 
#delivery of the scripts be liable for any damages whatsoever (including, 
#without limitation, damages for loss of business profits, business interruption, 
#loss of business information, or other pecuniary loss) arising out of the use 
#of or inability to use the sample scripts or documentation, even if Microsoft 
#has been advised of the possibility of such damages 
#--------------------------------------------------------------------------------- 
    Param
    (
        [Parameter(Mandatory=$true)]
        [Alias('pin')]
        [String[]]$PinItems
    )

    $Shell = New-Object -ComObject Shell.Application
    $Desktop = $Shell.NameSpace(0X0)

    Foreach($item in $PinItems)
    {
        #Verify the shortcut whether exists
        If(Test-Path -Path $item)
        {
        
        
            $itemLnk = $Desktop.ParseName($item)
        
            $Flag=0
	
            #pin application to windows Tasbar
            $itemVerbs = $itemLnk.Verbs()
            Foreach($itemVerb in $itemVerbs)
            {
                If($itemVerb.Name.Replace("&","") -match "Pin to Taskbar")
                {
                    $itemVerb.DoIt()
				    $Flag=1
                }
            }
		
		    #get the name of item
            $itemName = (Get-Item -Path $item).Name
		
		    If($Flag -eq 1)
            {
                Write-Host "Pin '$itemName' file to taskbar successfully." -ForegroundColor Green
            }
            Else
            {
                Write-Host "Failed to pin '$itemName' file to taskbar." -ForegroundColor Red
            }
         }
        Else
        {
            Write-Warning "Cannot find path '$item' because it does not exist."
        }
    }
}