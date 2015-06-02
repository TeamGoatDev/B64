#Xavier Hudon-Dansereau
#Script à lancer sur InterneUn
#Création des unité d'organisation
#---------------------------------

#Nom du domaine
$nomDom = "DC=CEGAT,DC=PRO"
$nomDomPlus = "OU=PROGRAMMATION,"+$nomDom

#Destruction de la UO "Programmation" et de son arborescence
Remove-ADOrganizationalUnit `
	-Identity ($nomDomPlus) `
	-Recursive `
	-Confirm:$false

#La recréation de la UO "Programmation"
New-ADOrganizationalUnit `
	-Name "PROGRAMMATION" `
	-Path $nomDom `
	-Description "PROGRAMMATION" `
	-ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Dev" `
    -Path $nomDomPlus `
    -Description "Dev" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "3D" `
    -Path "OU=Dev,$nomDomPlus" `
    -Description "3D" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "dotNET" `
    -Path "OU=Dev,$nomDomPlus" `
    -Description "dotNET" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Integrateurs" `
    -Path $nomDomPlus `
    -Description "Integrateurs" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Designers" `
    -Path $nomDomPlus `
    -Description "Designers" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Test" `
    -Path $nomDomPlus `
    -Description "Test" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Outils" `
    -Path "OU=Test,$nomDomPlus" `
    -Description "Outils" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Jeux" `
    -Path "OU=Test,$nomDomPlus" `
    -Description "Jeux" `
    -ProtectedFromAccidentalDeletion $false

New-ADOrganizationalUnit `
    -Name "Ordinateur" `
    -Path "OU=Test,$nomDomPlus" `
    -Description "Jeux" `
    -ProtectedFromAccidentalDeletion $false