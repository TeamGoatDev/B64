# SETUP DU SERVEUR 2


$nomCarte = "CEGAT"
$nomDomaine = "HYRULE.PRO"

Rename-NetAdapter -Name "Ethernet 6" -NewName $nomCarte

$netadapter = Get-NetAdapter -Name $nomCarte
$netadapter | New-NetIPAddress -IPAddress 192.168.0.12 -PrefixLength 24  -DefaultGateway 192.168.0.75


# DNS
Set-DnsClientServerAddress -InterfaceAlias $nomCarte -ServerAddresses 192.168.0.11


Add-WindowsFeature Web-Server -IncludeManagementTools


# CONNEXION AU DOMAINE

Add-Computer -ComputerName "." -DomainName $nomDomaine


New-Item -Path C:\_CEGAT_PRO -ItemType Directory


Read-Host "L'ordinateur va redémarrer"

Restart-Computer