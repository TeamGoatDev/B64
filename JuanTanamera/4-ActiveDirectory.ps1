######################################################
# Nom: Jean-William Perreault
# Date: 19 mai 2015
#
# Objectif: Installation de l'active directory
#
# COURS: B64
# Serveur d'�x�cution: Serveur Virtuel 1
# Serveurs modifi�s: Serveur Virtuel 1
# Ref�rences: 
#   -  http://www.thegeekstuff.com/2014/12/install-windows-ad/
######################################################
clear-host

#Param�tres
$nomDomaine = "HYRULE.PRO"


#Installation de Hyper-V
Install-windowsfeature AD-domain-services -IncludeManagementTools
Import-Module ADDSDeployment

#Cr�ation de la for�t de base
Install-ADDSForest `
 -DomainName $nomDomaine `
 -DomainMode "Win2012R2" `
 -InstallDns:$true `
 -ForestMode "Win2012R2" `
 -Force:$true