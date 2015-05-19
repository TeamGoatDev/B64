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



$numeroPoste = "25";

# Renommage de l'ordinateur Réel
Rename-Computer "408P$numeroPoste";

#Renommage Carte Réseau
Rename-NetAdapter -Name "Ethernet 4" -NewName "WAN"


#Changement adresse IP



#Redémarrage
Restart-Computer