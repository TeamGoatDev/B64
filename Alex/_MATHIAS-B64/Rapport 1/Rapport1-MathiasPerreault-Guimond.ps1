#Mathias Perreault-Guimond
#7 mai 2015
#Création des Unités d'organisation
#Exécuté à partir du Serveur 2
#Le serveur 2 sera la modifications

$ouRacine = "OU=PROGRAMMATION,"
$domName = $ouRacine+(Get-ADDomain).DistinguishedName

#Suppression des Unités d'organisation
#Remove-ADOrganizationalUnit -Identity $domName -Recursive

#Unité d'organisation Racine
New-ADOrganizationalUnit -Name 'PROGRAMMATION' -ProtectedFromAccidentalDeletion:$false

#Unité d'organisation Ordinateurs
New-ADOrganizationalUnit -Name 'Ordinateurs' -Path $domName -ProtectedFromAccidentalDeletion:$false

#Developpeurs
New-ADOrganizationalUnit -Name 'Developpeurs' -Path $domName -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name '3D' -Path "OU=Developpeurs,$domName" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name 'NET' -Path "OU=Developpeurs,$domName" -ProtectedFromAccidentalDeletion:$false

#Integrateurs
New-ADOrganizationalUnit -Name 'Integrateurs' -Path $domName -ProtectedFromAccidentalDeletion:$false

#Designers Web
New-ADOrganizationalUnit -Name 'DesignersWeb' -Path $domName -ProtectedFromAccidentalDeletion:$false

#Testeurs
New-ADOrganizationalUnit -Name 'Testeurs' -Path $domName -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name 'Outils' -Path "OU=Testeurs,$domName" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name 'Jeux' -Path "OU=Testeurs,$domName" -ProtectedFromAccidentalDeletion:$false
