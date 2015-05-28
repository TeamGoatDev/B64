#Xavier Hduon-Dansereau
#19/05/2015
#Script #1
#Remise #2
#Lancer à partir du serveur Réel
#Ce code modifie les configuration du serveur Réel
#------------------------------------------------------
#Déclaration
#------------
$reelName = "Externe";
$v1Name = "InterneUn";
$v2Name = "InterneDeux";
$v3Name = "Routeur";

$carteReelNom = (Get-NetAdapter -InterfaceDescription "Connexion Ethernet Intel(R) I217-LM").Name;
$carteReelNomR = "WAN_CONFIG"
$carteExterneNom = "Comm_Externe";
$carteInterneNom = "Comm_Interne";
$carteExterneNomR = "WAN";
$carteInterneNomR = "CEGAT";
#-------------
#Script
#-------------
#Lance la fonction "main"
main

function main{
    try{
        if(! (Get-WindowsFeature -Name hyper-v)){
            renameComputer;
            installHyperV;
            restartComputer;
        }
        else{
            "Hyper-V est déjà installé, voici la suite : "
            setExternalCard;
            renameBasicCard
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
        }
    }catch{
        Write-Host "Ça a merdé : " -ForegroundColor Red -BackgroundColor Black
        echo $_.Exception.GetType().FullName
        echo $_.Exception.Message
    }
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
    Write-Host "Redémarage du PC" -ForegroundColor Red -BackgroundColor Black
    
    Restart-Computer -Force
}

function renameBasicCard{
    Write-Host "Changement du nom de la carte par défaut" -ForegroundColor Green
    Rename-NetAdapter -Name $carteReelNom -NewName $carteReelNomR
}

function setExternalCard{
    #"Retrait de l'ancienne adresse IP"
    #Remove-NetIPAddress -IPAddress (Get-NetIPAddress -InterfaceAlias $adapter.Name).IPv4Address

    Write-Host "Ajout d'une nouvelle adresse IP" -ForegroundColor Green
    
    new-NetIPAddress -InterfaceAlias $carteReelNom `
	-IPAddress 10.57.64.23 `
	-PrefixLength 16 `
	-AddressFamily IPV4 `
	-DefaultGateway 10.57.1.1

    Write-Host "Ajout des parametres de DNS" -ForegroundColor Green
    
    Set-DnsClientServerAddress -InterfaceAlias $carteReelNom `
	-ServerAddresses ("10.57.4.28","10.57.4.29")
}

function addVirtualSwitch{
    Write-Host "Suppression des anciennes cartes virtuels" -ForegroundColor Green
    Remove-VMSwitch -VMSwitch (Get-VMSwitch) -Force

    Write-Host "Ajout de la carte virtuel externe" -ForegroundColor Green
    New-VMSwitch -Name $carteExterneNom -NetAdapterName $carteReelNomR
    
    Write-Host "Ajout de la carte virtuel interne" -ForegroundColor Green
    New-VMSwitch -SwitchType Internal -Name $carteInterneNom

    Write-Host "Changement du nom des cartes virtuels" -ForegroundColor Green
    Rename-NetAdapter -Name "vEthernet ($carteExterneNom)" -NewName $carteExterneNomR
    Rename-NetAdapter -Name "vEthernet ($carteInterneNom)" -NewName $carteInterneNomR
}

function creerVM{
    Write-Host "Creation des Machines Virtuels" -ForegroundColor Green
    if(Get-VM -Name $v1Name){
        Remove-VM -Name $v1Name -Force
    }
    if(Get-VM -Name $v1Name){
        Remove-VM -Name $v2Name -Force
    }
    if(Get-VM -Name $v1Name){
        Remove-VM -Name $v3Name -Force
    }

    New-VM -Name $v1Name `
	-MemoryStartupBytes 4096mb `
	-VHDPath c:\_VirDisque\S1_PROJET.vhdx `
	-Path c:/_VirOrdi
    New-VM -Name $v2Name `
	-MemoryStartupBytes 4096mb `
	-VHDPath c:\_VirDisque\S2_PROJET.vhdx `
	-Path c:/_VirOrdi
    New-VM -Name $v3Name `
	-MemoryStartupBytes 512mb `
	-VHDPath c:\_VirDisque\Routeur_Projet.vhd `
	-Path c:/_VirOrdi
}

function addAdapter($VMnom){
    Write-Host "Ajout de l'Adaptateur" -ForegroundColor Green
    Get-VMNetworkAdapter -VMName $VMnom | Remove-VMNetworkAdapter
    Add-VMNetworkAdapter -VMName $VMnom -Name $carteInterneNom -IsLegacy $true
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
    #https://social.technet.microsoft.com/Forums/windowsserver/en-US/abde2699+
	#-0d5a-49ad-bfda-e87d903dd865/disable-windows-update-via-powershell?forum=winserverpowershell
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
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\"+`
	"Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\"+`
	"Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer.exe
    Start-Process Explorer.exe
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}