#-------------------------------------------------------------------
# Richard Jean
# janvier 2015
#-------------------------------------------------------------------

Clear-Host

#-------------------------------------------------------------------
# Le CD (ATTENTION AVEC CD SERVEUR !!!)
#-------------------------------------------------------------------
$ordi="B64HV1"
$chemin="\\" + $ordi + "\c$\_B64_"

# Supprime les anciens dossiers sur le CD
try
{
  Remove-Item -Path $chemin"*" -Force -Recurse -ErrorAction Stop
}
catch [System.Management.Automation.ItemNotFoundException]
{
  Write-Host "Le dossier $chemin n'existe pas." -ForegroundColor Yellow
}

# Supprime les anciens partages sur le CD
Get-SmbShare -Name B64_* -CimSession $ordi | Remove-SmbShare -Force

# Les nouveaux dossiers sur le CD
new-item -itemtype directory -path $chemin"Clients"
new-item -itemtype directory -path $chemin"Inventaire"
new-item -itemtype directory -path $chemin"Publicite"
new-item -itemtype directory -path $chemin"Publicite\B64BOIBE"
new-item -itemtype directory -path $chemin"Publicite\B64CHECA"
new-item -itemtype directory -path $chemin"Publicite\B64CHRDO"
new-item -itemtype directory -path $chemin"Publicite\B64CUEEM"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Clients" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Clients" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Clients" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Clients" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Clients" --% /grant directeurs:(CI)(OI)(RX)

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Inventaire" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Inventaire" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Inventaire" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Inventaire" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Inventaire" --% /grant directeurs:(CI)(OI)(RX)

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Publicite" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Publicite" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Publicite" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Publicite" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Publicite" --% /grant Directeurs:(RX)

# Ajout des autorisations NTFS
  icacls.exe $chemin"Publicite\B64BOIBE"  --% /grant B64BOIBE:(CI)(OI)(M)
  icacls.exe $chemin"Publicite\B64CHECA"  --% /grant B64CHECA:(CI)(OI)(M)
  icacls.exe $chemin"Publicite\B64CHRDO"  --% /grant B64CHRDO:(CI)(OI)(M)
  icacls.exe $chemin"Publicite\B64CUEEM"  --% /grant B64CUEEM:(CI)(OI)(M)

# Les nouveaux partages sur le CD
New-SMBShare -Name B64_Cli  -Path C:\_B64_Clients    -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi 
New-SMBShare -Name B64_InvB -Path C:\_B64_Inventaire -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi 
New-SMBShare -Name B64_Pub  -Path C:\_B64_Publicite  -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi

#-------------------------------------------------------------------
# Les nouveaux dossiers sur le "Serveur virtuel 2"
#-------------------------------------------------------------------
$ordi="B64HV2"
$chemin="\\" + $ordi + "\c$\_B64_"

# Supprime les anciens dossiers sur le "Serveur virtuel 2"
try
{
  Remove-Item -Path $chemin"*" -Force -Recurse -ErrorAction Stop
}
catch [System.Management.Automation.ItemNotFoundException]
{
  Write-Host "Le dossier $chemin n'existe pas." -ForegroundColor Yellow
}

# Supprime les anciens partages sur le "Serveur virtuel 2"
Get-SmbShare -Name B64_* -CimSession $ordi | Remove-SmbShare -Force

# Les nouveaux dossiers sur le "Serveur virtuel 2"
new-item -itemtype directory -path $chemin"Commande"
new-item -itemtype directory -path $chemin"Inventaire"
new-item -itemtype directory -path $chemin"Production"
new-item -itemtype directory -path $chemin"Web"

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Commande" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Commande" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Commande" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Commande" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Commande" --% /grant Directeurs:(CI)(OI)(M)

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Inventaire" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Inventaire" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Inventaire" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Inventaire" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Inventaire" --% /grant directeurs:(CI)(OI)(RX)

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Production" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Production" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Production" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Production" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Production" --% /grant directeurs:(CI)(OI)(RX)
  icacls.exe $chemin"Production" --% /grant B64CUEEM:(CI)(OI)(M)

#"Désactiver l’héritage" et "Supprimer toutes les autorisations héritées de cet objet"
  icacls.exe $chemin"Web" /inheritance:r
# Ajout des autorisations NTFS
  icacls.exe $chemin"Web" --% /grant TECH:(CI)(OI)(F)
  icacls.exe $chemin"Web" --% /grant system:(CI)(OI)(F)
  icacls.exe $chemin"Web" --% /grant administrateurs:(CI)(OI)(F)
  icacls.exe $chemin"Web" --% /grant directeurs:(CI)(OI)(RX)

# Les nouveaux partages sur le "Serveur virtuel 2"
New-SMBShare -Name B64_Cmd  -Path C:\_B64_Commande    -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi
New-SMBShare -Name B64_InvA -Path C:\_B64_Inventaire  -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi
New-SMBShare -Name B64_Prod -Path C:\_B64_Production  -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi
New-SMBShare -Name B64_Web  -Path C:\_B64_Web         -FullAccess "Tout le monde" -CachingMode none -CIMSession $ordi
