# AUTEUR: Richard Jean , Département d'informatique
# DATE:   février 2015
#Modification : Xavier Hudon-Dansereau
#==========================================================================
Clear-Host

#Nom du fichier de données
$fCsv = "C:\Users\Tech\Desktop\B64_L03C_UO.csv"

#Nom de notre domaine
$nomDom = "DC=dalton,DC=b64"

$codePays = "CA"
$nomPays  = "CANADA"
$noPays   = 124

#Destruction de la UO B64 et de son arborescence
Remove-ADOrganizationalUnit `
	-Identity ("OU=B64," + $nomDom)`
	-Recursive `
	-Confirm:$false

#La création de la UO B64 sous le domaine "DC=Dalton,DC=B64"
New-ADOrganizationalUnit `
	-Name "B64" `
	-Path $nomDom `
	-Description "B64" `
	-OtherAttributes @{'c'=$codePays;'co'=$nomPays;'countryCode'=$noPays} `
	-ProtectedFromAccidentalDeletion $false

Write-Host "Création de la OU B64"

#Création de la structure des UO via le fichier CSV
#La structure sera sous "OU=B64,DC=Dalton,DC=B64"
$oCsv = Import-Csv -path $fCsv -Delimiter ";"

$Compte =0

Foreach ($Ligne in $oCsv)
{
  $Parent = $Ligne.aParent + "," + $nomDom
  $NomOu = $Ligne.aOu
  $Desc = $Ligne.aDesc
	
  New-ADOrganizationalUnit `
    -Name $NomOu `
    -Path $Parent `
    -Description $Desc `
    -ProtectedFromAccidentalDeletion $false

  $Compte++
}

Write-Host "Création de $Compte unités sous B64"
