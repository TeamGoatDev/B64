######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Changement du nom de l'ordinateur 
# + plan d'adressage de base
#
# Serveur d'éxécution: SERVEUR RÉEL
# Serveurs modifiés: SERVEUR RÉEL
######################################################

#Paramètres
$nouveaNomCarte = "WAN"
$nouvelleAdresse = "10.57.61.25"
$masqueBits = 16
$passerelle = "10.57.1.1"
$dns1 = "10.57.4.28"
$dns2 = "10.57.4.29"


#Obtention numéro de psote
$numeroPoste = Read-Host "Entrer le numéro de votre poste: "  #25

# Renommage de l'ordinateur Réel
Rename-Computer "408P$numeroPoste";

#Renommage Carte Réseau
Rename-NetAdapter -Name "Ethernet 4" -NewName $nouveaNomCarte


#Changement adresse IP
New-NetIPAddress –InterfaceAlias $nouveaNomCarte –IPv4Address $nouvelleAdresse –PrefixLength $masqueBits -DefaultGateway $passerelle
# DNS
Set-DnsClientServerAddress -InterfaceAlias $nouveaNomCarte -ServerAddresses $dns1, $dns2


#Redémarrage
Restart-Computer