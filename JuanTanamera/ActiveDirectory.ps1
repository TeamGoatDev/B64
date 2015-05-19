######################################################
# Nom: Jean-William Perreault
# Date: 19 mai 2015
#
# Objectif: Installation de l'active directory
#
# Serveur d'éxécution: Serveur Virtuel 1
# Serveurs modifiés: Serveur Virtuel 1
# Reférences: 
#   -  http://www.thegeekstuff.com/2014/12/install-windows-ad/
######################################################

#Paramètres
$nomDomaine = "HYRULE.PRO"


#Installation de Hyper-V
Install-windowsfeature AD-domain-services
Import-Module ADDSDeployment

#Création de la forêt de base
Install-ADDSForest `
 -DomainName $nomDomaine `
 -DomainMode "Win2012R2" `
 -InstallDns:$true `
 -ForestMode "Win2012R2" `
 -Force:$true