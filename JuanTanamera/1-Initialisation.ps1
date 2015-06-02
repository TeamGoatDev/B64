######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Changement du nom de l'ordinateur 
# + plan d'adressage de base
# Cours: B64
# Serveur d'�x�cution: SERVEUR R�EL
# Serveurs modifi�s: SERVEUR R�EL
######################################################

#Param�tres
$nomCarte = "Ethernet 4"
$masqueBits = 16
$passerelle = "10.57.1.1"
$dns1 = "10.57.4.28"
$dns2 = "10.57.4.29"

clear-host

#Obtention num�ro de psote
$numeroPoste = Read-Host "Entrer le num�ro de votre poste: "  #25

$nouvelleAdresse = "10.57.64.$numeroPoste"

# Renommage de l'ordinateur R�el
Rename-Computer "CegExt";


#Changement adresse IP
New-NetIPAddress �InterfaceAlias $nomCarte �IPAddress $nouvelleAdresse �PrefixLength $masqueBits -DefaultGateway $passerelle -ErrorAction Ignore


# DNS
Set-DnsClientServerAddress -InterfaceAlias $nomCarte -ServerAddresses $dns1, $dns2


#Red�marrage
Restart-Computer