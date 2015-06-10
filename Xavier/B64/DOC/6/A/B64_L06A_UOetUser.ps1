# AUTEUR: Richard Jean , Département d'informatique
# DATE:   février 2015
#Modification : Xavier Hudon-Dansereau
#==========================================================================
Clear-Host

#Nom du fichier de données
$fCsv = "C:\Users\Tech\Desktop\Fichier\6\B64_L06A_xDonnees.csv"

#Nom de notre domaine
$nomDom = "OU=B64,DC=dalton,DC=b64"
$nomDNS = (Get-ADDomain).DNSRoot
$mdp = "AAAaaa111"

# Les 3 paramètres pour le pays Canada
$codePays = "CA"
$nomPays  = "CANADA"
$noPays   = 124

#Création de la structure des UO via le fichier CSV
#La structure sera sous "OU=B64,DC=Dalton,DC=B64"
$oCsv = Import-Csv -path $fCsv -Delimiter ";"

$Compte =0

Get-ADUser -Filter "Name -like 'B64*'" | Remove-ADUser

Foreach ($Ligne in $oCsv)
{
  $Parent = $Ligne.Chemin + "," + $nomDom
  $Prenom = $Ligne.givenName
  $Nom = $Ligne.sn
  $LongueurP = 2
  $LongueurN = 3
  if($Prenom.Length -lt $LongueurP){
    $LongueurP = $Prenom.Length
    echo $Prenom+"_____+_____-----_________"
  }
  if($Nom.Length -lt $LongueurN){
    $LongueurN = $Nom.Length
    echo $Nom+"__________-----_________"
  }
  $NomComplet = "B64"+$Nom.ToLower().Substring(0,$LongueurN)+$Prenom.ToLower().Substring(0,$LongueurP)
  
  $Telephone = $Ligne.telephoneNumber
  $Addresse = $Ligne.streetAddress
  $Ville = $Ligne.l
  $Desc = "Utilisateur de B64"

  echo $NomComplet


  New-ADUser -Name $NomComplet `
	-UserPrincipalName "$NomComplet@$NomDNS" `
	-Path $Parent `
	-GivenName $Prenom `
	-Surname $Nom `
	-DisplayName "$Prenom $Nom" `
	-Description $Desc `
	-OfficePhone $Telephone `
	-StreetAddress $Addresse `
	-OtherAttributes @{'c'=$codePays;'co'=$nomPays;'countryCode'=$noPays; `
                       'otherTelephone'="514-982-7000","514-982-9999" }  `
	-AccountPassword (ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force) `
	-PasswordNeverExpires $true `
    -CannotChangePassword $true `
	-Enabled $true
  $Compte++
}

Write-Host "Création de $Compte unités sous B64"
