######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Changement du nom de l'ordinateur 
# + plan d'adressage de base
# Cours: B64
# Serveur d'éxécution: SERVEUR RÉEL
# Serveurs modifiés: SERVEUR RÉEL
######################################################

#Paramètres
$nomCarte = "Ethernet 4"
$masqueBits = 16
$passerelle = "10.57.1.1"
$dns1 = "10.57.4.28"
$dns2 = "10.57.4.29"

clear-host

#Obtention numéro de psote
$numeroPoste = Read-Host "Entrer le numéro de votre poste: "  #25

$nouvelleAdresse = "10.57.64.$numeroPoste"

# Renommage de l'ordinateur Réel
Rename-Computer "CegExt";


#Changement adresse IP
New-NetIPAddress –InterfaceAlias $nomCarte –IPAddress $nouvelleAdresse –PrefixLength $masqueBits -DefaultGateway $passerelle -ErrorAction Ignore


# DNS
Set-DnsClientServerAddress -InterfaceAlias $nomCarte -ServerAddresses $dns1, $dns2


#Redémarrage
Restart-Computer