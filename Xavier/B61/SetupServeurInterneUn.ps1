#Xavier Hduon-Dansereau
#05/05/2015
#Script #1
#Lancer à partir du serveur InterneUn
#Ce code modifie les configurations du serveur InterneUn
#------------------------------------------------------
#Déclaration
#------------
$reelName = "Externe";
$v1Name = "InterneUn";
$v2Name = "InterneDeux";
$v3Name = "Routeur";

$carteNom = (Get-NetAdapter).Name;

#-------------
#Script
#-------------
try{
    if(! (Get-WindowsFeature -Name AD-domain-services)){
        installGrosService;
        restartComputer;
    }
    else{
        setCard;
        setNomDomaine;
        enableBureauDistance;
    }
}catch{
    echo "Ça a merdé : "
    echo $_.Exception.GetType().FullName
    echo $_.Exception.Message
}

function installGrosService{
    Add-WindowsFeature -Name DNS –IncludeManagementTools
    Add-WindowsFeature -Name AD-domain-services -IncludeAllSubFeature -IncludeManagementTools
    Add-WindowsFeature -Name AD-Certificate -IncludeAllSubFeature -IncludeManagementTools
}

function restartComputer{
    Write-Host "Redémarage du PC dans 5 secondes, pèse sur 'CTRL+C' pour annuler" -ForegroundColor Red -BackgroundColor Black
    Start-Sleep -s 5
    Restart-Computer -Force
}

function setCard{
    #"Retrait de l'ancienne adresse IP"
    #Remove-NetIPAddress -IPAddress (Get-NetIPAddress -InterfaceAlias $adapter.Name).IPv4Address

    Write-Host "Ajout d'une nouvelle adresse IP" -ForegroundColor Green
    New-NetIPAddress -InterfaceAlias $carteNom -IPAddress 192.168.0.10 -PrefixLength 16 -AddressFamily IPV4 -DefaultGateway 192.168.0.75

    Write-Host "Ajout des parametres de DNS" -ForegroundColor Green
    Set-DnsClientServerAddress -InterfaceAlias $carteNom -ServerAddresses ("127.0.0.1")
}

function setNomDomain{
    Add-Computer -DomainName CEGAT.PRO
}

function enableBureauDistance{
#http://networkerslog.blogspot.ca/2013/09/how-to-enable-remote-desktop-remotely.html
    set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1  
}