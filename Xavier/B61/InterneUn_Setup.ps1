#Xavier Hudon-Dansereau
#Scrip à lancer sur InterneUn

$NetAdapter = Get-NetAdapter;

main

function main{
    if((Get-WindowsFeature -Name AD-domain-services).installState -eq "Avalaible"){
        installFeature;
        restart;
    }else{
        addComputerToDomain;
        Install-WindowsFeature -Name AD-Certificate #doit etre fait après le changement de nom de domaine de l'ordi
        setNetworkCard;
        showExtention;
        disableAutoUpdate;
        disable_IE_IntrusiveSecurity;
        disableServerManagerOnStartup;
        enableRemoteDesktop;
    }
}

function installFeature{
    Install-WindowsFeature -Name  AD-domain-services -IncludeManagementTools
    Install-ADDSForest -DomainName "CEGAT.PRO" `
        -InstallDns:$true `
        -DomainNetbiosName "CEGAT.PRO" - `
        -DomainMode "Win2012" `
        -
    Install-WindowsFeature -Name DNS
    
}
function addComputerToDomain{
    $domain = "CEGAT.PRO"
    $user = Read-Host -Prompt "Enter username"
 
    $password = Read-Host -Prompt "Enter password for $user" -AsSecureString 
    $username = "$domain\$user" 
    $credential = New-Object System.Management.Automation.PSCredential($username,$password) 
    Add-Computer -DomainName $domain -Credential $credential
}
function restart{
    Write-Host "Redémarage du PC" -ForegroundColor Red -BackgroundColor Black
    
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