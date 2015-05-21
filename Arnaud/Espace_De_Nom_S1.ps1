#Nom : Arnaud Girardin
#Date : 2015-05-11
#Description : Espace de Nom
#Source : Serveur 1 (AXE)
#Modifications : Serveur 2 (LUNA)

#Nom du serveur
$serveur = "LUNA"

#Creation d'une CimSession
$cim = New-CimSession -ComputerName $serveur;

#Creation du de la racine DFS------------------------------------------------------------------------------------------

#Creation du dossier
New-Item -Path \\$serveur\C$\DFSROOT -ItemType directory -Force

#Autorisations
icacls "\\$serveur\C$\DFSROOT" /inheritance:r
icacls "\\$serveur\C$\DFSROOT" /grant "Administrateurs:(CI)(OI)(F)"
icacls "\\$serveur\C$\DFSROOT" /grant "Tout le monde:(CI)(OI)(R)"

#Creation du partage
New-SmbShare -Name _DFSROOT `
             -Path C:\DFSROOT `
             -CimSession $cim `
             -FolderEnumerationMode AccessBased `
             -CachingMode None
             
#Creation de la racine
New-DfsnRoot -Path "\\AXE.PRO\DFSROOT" -TargetPath "\\$serveur\_DFSROOT"  -EnableAccessBasedEnumeration $true;

#----------------------------------------------------------------------------------------------------------------------







