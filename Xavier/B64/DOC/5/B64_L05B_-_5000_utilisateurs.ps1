#==========================================================================
# Technique: Création de 5000 utilisateurs en utilisant un formatage précis
#
# AUTEUR: Richard Jean
#         Département d'informatique
#
# DATE:   7 mars 2015
#==========================================================================
Clear-Host

# Commande pour EFFACER les 5000 utilisateurs dont le nom débute par "ETU*"
# Get-ADUser -Filter 'Name -like "ETU*"' | Remove-ADUser -Confirm:$false

$nomDNS = (Get-ADDomain).DNSRoot

$total = 5000

for ($userIndex=0; $userIndex -lt $total; $userIndex++) 
{ 
  # Utilisation du formatage pour forcer la représentation d'un nombre sur 4 colonnes
  $userID = "{0:0000}" -f ($userIndex + 1)
  
  $userName = "ETU$userID"

  Write-Host "Création de l'utilisateur" ($userIndex + 1) "of" $total ":" $userName
  
  # Si on n'utilise pas le paramètre -PATH alors les utilisateurs seront dans le conteneur "Users"
  # INFORMATION: on ne peut pas utiliser le mot de passe AAAaaa111
  # RAISON: le mot de passe ne doit pas contenir le nom de compte de l’utilisateur ou
  # des parties du nom complet de l’utilisateur comptant plus de deux caractères successifs
  New-ADuser -Name $userName `
             -UserPrincipalName "$userName@$NomDNS" `
             -GivenName "ETUDIANT" `
             -Surname $userIndex `
             -DisplayName "ETUDIANT $userIndex" `
             -AccountPassword (ConvertTo-SecureString -AsPlainText "ASDqwe!!!" -Force) `
             -PasswordNeverExpires $true `
             -Enabled $true
}
