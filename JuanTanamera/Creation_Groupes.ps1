######################################################
# Nom: Jean-William Perreault
# Date: 14 mai 2015
#
# Objectif: CRÉATION DES GROUPES 
#
# Serveur d'éxécution: SERVEUR 1 (Contrôleur de Domaine)
# Serveurs modifiés: SERVEUR 1 (Contrôleur de Domaine)
######################################################

#PARAMÈTRES
$DC =  (Get-ADDomain).DistinguishedName;
$cheminDesGroupes = "OU=PROGRAMMATION,$DC"
$groupes = @(
    "Developpeur .NET",
    "Developpeur 3D",
    "GrIntégrateurs",
    "Designers WEB",
    "Testeurs d'outils",
    "Testeurs de Jeux",
    "Gestionnaires"
)

#Création des Groupes
foreach($groupe in $groupes){
    
    New-ADGroup `
    -GroupScope Global `
    -Name $groupe `
    -Description "Groupe des $groupe" `
    -GroupCategory Security `
    -Path $cheminDesGroupes

}