######################################################
# Nom: Jean-William Perreault
# Date: 14 mai 2015
#
# Objectif: CRÉATION DES OU 
#
# Serveur d'éxécution: SERVEUR 1 (Contrôleur de Domaine)
# Serveurs modifiés: SERVEUR 1 (Contrôleur de Domaine)
######################################################

Clear-Host

import-module -Name grouppolicy

$DC = (Get-ADDomain).DistinguishedName;
$prog = "PROGRAMMATION"
$developpeurs = "Developpement"
$devWeb = "DeveloppementWEB"
$integrateurs = "Integration"
$testeurs = "Tests"
$ordinateurs = "Ordinateurs"


#RACINE PROGRAMMTION
New-ADOrganizationalUnit -Name $prog -path "$DC" -ProtectedFromAccidentalDeletion:$false

#DEVELOPPEURS
New-ADOrganizationalUnit -Name $developpeurs -path "OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name "3D" -path "OU=$developpeurs,OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name ".NET" -path "OU=$developpeurs,OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false

#INTEGRATEURS
New-ADOrganizationalUnit -Name $integrateurs -path "OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name $devWeb -path "OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false

#TESTEURS
New-ADOrganizationalUnit -Name $testeurs -path "OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name "Outils" -path "OU=$testeurs,OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name "Jeux" -path "OU=$testeurs,OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false

#ORDINATEURS
New-ADOrganizationalUnit -Name $ordinateurs -path "OU=$prog,$DC" -ProtectedFromAccidentalDeletion:$false

Write-Host "Structure OU créée avec succès" -ForegroundColor Green