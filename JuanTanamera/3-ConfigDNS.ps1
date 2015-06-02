# Nom: Jean-William Perreault
# Date: 19 mai 2015
#
# Objectif: 
#    - Installation du rôle DNS 
#    - Paramétrage de la carte réseau
#
# COURS: B64
# Serveur d'éxécution: Serveur Virtuel 1 (CegKontrol)
# Serveurs modifiés: Serveur Virtuel 1 (CegKontrol)
######################################################

$nomCarte = "CEGAT"

Install-WindowsFeature DNS -IncludeManagementTools
Rename-NetAdapter -Name "Ethernet 6" -NewName $nomCarte

$netadapter = Get-NetAdapter -Name $nomCarte
$netadapter | New-NetIPAddress -IPAddress 192.168.0.11 -PrefixLength 24 -DefaultGateway 192.168.0.75



#Ajout redirecteur dep CÉGEP
Add-DnsForwarder @("10.57.4.28", "10.57.4.29")

Write-Host "DNS TERMINÉ" -ForegroundColor Green