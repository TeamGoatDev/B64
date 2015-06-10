#==========================================================================
# AUTEUR: Richard Jean 
# DATE  : Février 2015
#
# Création d'un utilisateur à l'aide des cmdlets du module ActiveDirectory
# L'utilisateur sera créé directement sous l'unité B64
#==========================================================================
Clear-Host

# Utilisation de deux propriétés du domaine
$nomDom = (Get-ADDomain).DistinguishedName
$nomDNS = (Get-ADDomain).DNSRoot

# Les 3 paramètres pour le pays Canada
$codePays = "CA"
$nomPays  = "CANADA"
$noPays   = 124

# B64 est directement sous le domaine
$cheminOU = "OU=B64,$nomDom"
$Prenom   = "LOREM"
$Nom      = "IPSUM"
$Desc     = "Utilisateur de B64"

# Le nom d'ouverture de session sera le PRÉNOM
$loginName = $Prenom

# On efface le compte utilisateur avant de le créer
try
{
  Get-ADUser $loginName | Out-Null
  Write-Host "Le compte utilisateur $loginName existe, donc on l'efface." 

  Remove-ADUser -identity $loginName -Confirm:$False
}
catch 
{
  Write-Host "Le compte $loginName n'existe pas." -ForegroundColor Yellow
}

# IMPORTANT: création du compte utilisateur
# Si on ne déclare pas le paramètre -SamAccountName
# Le contenu de -SamAccountName sera le même que le paramètre -Name
New-ADUser -Name $loginName `
	-UserPrincipalName "$loginName@$NomDNS" `
	-Path $cheminOU `
	-GivenName $Prenom `
	-Surname $Nom `
	-DisplayName "$Prenom $Nom" `
	-Description $Desc `
    -Office "INFORMATIQUE" `
	-OfficePhone "514-982-3437" `
	-HomePhone "450-222-2222" `
	-MobilePhone "450-333-3333" `
	-Fax "450-444-4444" `
	-EmailAddress "$loginName@DALTON.B64" `
	-HomePage "WWW.DALTON.B64" `
	-OtherAttributes @{'c'=$codePays;'co'=$nomPays;'countryCode'=$noPays; `
                       'otherTelephone'="514-982-7000","514-982-9999" }  `
	-AccountPassword (ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force) `
	-PasswordNeverExpires $true `
	-Enabled $true

Write-Host "Fin de la création du compte utilisateur $loginName"
