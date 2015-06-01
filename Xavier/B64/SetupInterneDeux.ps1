#Xavier Hduon-Dansereau
#05/05/2015
#Scrip à lancer sur InterneDeux (Client, IIS)
#Lancer à partir du serveur InterneDeux après avoir setup le serveur InterneUn
#Ce code modifie les configurations du serveur InterneDeux
#------------------------------------------------------------------------------
#Déclaration
#------------

$NetAdapter = Get-NetAdapter;

#-------------
#Script
#-------------

main

function main{
    try{
        if((Get-WindowsFeature -Name AD-domain-services).installState -eq "Avalaible"){
            installFeature;
            restart;
        }else{
            addComputerToDomain;
            setNomDomain;
            setNetworkCard;
            showExtention;
            disableAutoUpdate;
            disable_IE_IntrusiveSecurity;
            disableServerManagerOnStartup;
            enableRemoteDesktop;
        }
    }catch{
        echo "Ça a merdé : "
        echo $_.Exception.GetType().FullName
        echo $_.Exception.Message
    }
}

function installFeature{
    Write-Host "Install des gros features cad : iis" -ForegroundColor Green
    Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
}
function addComputerToDomain{
    $domain = "CEGAT.PRO"
    $server = "InterneUn"
    $user = Read-Host -Prompt "Enter username"
 
    $password = Read-Host -Prompt "Enter password for $user" -AsSecureString 
    $username = "$domain\$user" 
    $credential = New-Object System.Management.Automation.PSCredential($username,$password) 
    Add-Computer -DomainName $domain -Server $server -Credential $credential
}
function restart{
    Write-Host "Redémarage du PC dans 5 secondes, pèse sur 'CTRL+C' pour annuler" -ForegroundColor Red -BackgroundColor Black
    Start-Sleep -s 5
    Restart-Computer -Force
}
function setNetworkCard{
    Write-Host "Setting network Card" -ForegroundColor Green

    New-NetIPAddress -InterfaceAlias $NetAdapter.InterfaceAlias `
	-IPAddress 192.168.0.10 `
	-PrefixLength 24 `
	-AddressFamily IPV4 `
	-DefaultGateway 192.168.0.1

    Write-Host "Ajout des parametres de DNS" -ForegroundColor Green
    
    Set-DnsClientServerAddress -InterfaceAlias $NetAdapter.InterfaceAlias `
	-ServerAddresses ("127.0.0.1")
}



function setupSitesWebEtFtp{
    Write-Host "Création des sites web et ftp" -ForegroundColor Green

    $path1 = "C:\_CEGAT_PRO\WEBD"
    $path2 = "C:\_CEGAT_PRO\WEBS"
    $path3 = "C:\_CEGAT_PRO\FTPD"
    $path4 = "C:\_CEGAT_PRO\FTPA"

    Import-Module WebAdministration

    New-Item -Path $path1 -ItemType directory -Force
    New-Item $path1+"\"+index.htm -type file -Force
    "WEBD / Interieur+Exterieur / Xavier / 192.168.0.20" | Out-File $path1+"\"+index.htm -Append
    New-Website -Name "PRO" -Port 80 -IPAddress "192.168.0.20" -PhysicalPath $path1

    New-Item -Path $path2 -ItemType directory -Force
    New-Item $path2+"\"+index.htm -type file
    "WEBS Secure / Interieur / Xavier / 192.168.0.20" | Out-File $path2+"\"+index.htm -Append
    New-Website -Name "SECPRO" -Port 443 -IPAddress "192.168.0.20" -PhysicalPath $path2 -ssl

    New-Item -Path $path3 -ItemType directory -Force
    New-Item $path3+"\"+testFile.txt -type file
    "FTPD / Interieur+Exterieur / Xavier / 192.168.0.20" | Out-File $path3+"\"+testFile.txt -Append
    New-WebFtpSite -Name "FDPRO" -IPAddress "192.168.0.20" -Port "21" -PhysicalPath $path3

    New-Item -Path $path4 -ItemType directory -Force
    New-Item $path4+"\"+testFile.txt -type file
    "FTPA / Interieur+Exterieur / Xavier / 192.168.0.20" | Out-File $path4+"\"+testFile.txt -Append
    New-WebFtpSite -Name "FPRO" -IPAddress "192.168.0.20" -Port "21" -PhysicalPath $path4

    Set-ItemProperty IIS:\Sites\FTPA -Name ftpServer.security.ssl.controlChannelPolicy -Value 1
    Set-ItemProperty IIS:\Sites\FTPA -Name ftpServer.security.ssl.dataChannelPolicy -Value 1
}














function showExtention{
    Write-Host "Affichage des extentions" -ForegroundColor Green
    
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $key Hidden 1
    Set-ItemProperty $key HideFileExt 0
    Set-ItemProperty $key ShowSuperHidden 1
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
function disableServerManagerOnStartup{
    Write-Host "Disabling serverManager on startup" -ForegroundColor Green
    Disable-ScheduledTask -TaskPath ‘\Microsoft\Windows\Server Manager\’ -TaskName ‘ServerManager’
}
function enableRemoteDesktop{
    Write-Host "Enable Remote Desktop" -ForegroundColor Green
    set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

    Write-Host "Allow incoming RDP on firewall" -ForegroundColor Green
    Enable-NetFirewallRule -DisplayGroup "Bureau à distance"

    Write-Host "Enable secure RDP authentication" -ForegroundColor Green
    set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1 
}