######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Changement du nom de l'ordinateur 
# + plan d'adressage de base
#
# Serveur d'�x�cution: SERVEUR R�EL
# Serveurs modifi�s: SERVEUR R�EL
######################################################



$numeroPoste = "25";

# Renommage de l'ordinateur R�el
Rename-Computer "408P$numeroPoste";

#Renommage Carte R�seau
Rename-NetAdapter -Name "Ethernet 4" -NewName "WAN"


#Changement adresse IP



#Red�marrage
Restart-Computer