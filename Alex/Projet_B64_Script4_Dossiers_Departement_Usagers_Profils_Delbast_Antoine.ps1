################################
# Créations des dossiers       #
# personnels,de département et # 
# autorisations                #
#Par Antoine Delbast           #
#remis 14                      #
#Exécuté sur serveur 2		   #
#Modifie Serveur     1 et 2    #
################################


$fCsv = "Prog.csv"
$csvUsagers = Import-Csv -path $fCsv -delimiter ";" -encoding default
$serveur1 = "Tails"
$path_profils = "\\$serveur1\Profils\"


#Création des dossiers personnels

new-item -ItemType directory -Path \\Tails\c$\_CEGAT_PRO
New-Item -ItemType directory -Path \\Tails\c$\_CEGAT_PRO\Usagers
New-SmbShare –Name "Usagers" –Path \\Tails\c$\_CEGAT_PRO\Usagers  -FullAccess Administrators, System -FolderEnumerationMode AccessBased	

foreach($Usager in $csvUsagers)
{
	$nom = $Usager.Matricule
	$homeDirectory = "\\$serveur1\Users$\$Usager.Nom"
	
    New-Item -ItemType directory -Path $homeDirectory
    icacls $homeDirectory /grant $nom`:`(OI`)`(CI`)M /t
	icacls $homeDirectory /grant "Gestionnaire:(OI)(CI)(RX)" "SYSTEM:(OI)(CI)(F)" "Administrateurs:(OI)(CI)(F)"  
	
	New-SmbShare –Name ($nom + "_Home") –Path $path_profils  -FullAccess Administrators, System -FolderEnumerationMode AccessBased
	Grant-SmbShareAccess ($nom + "_Home") –AccountName $nom –AccessRight Change
}

#Créations des dossiers de profils

New-Item -ItemType directory -Path $path_profils
New-SmbShare –Name "Profils" –Path $path_profils  -FullAccess Administrators, System -FolderEnumerationMode AccessBased	

FOREACH ($Usagers in $csvUsagers) 
{
	
	$nom = $Usagers.Matricule
	$profilDirectory = ($path_profils + $nom + ".V4")
		
	New-Item -ItemType directory -Path $profilDirectory
	icacls $homeDirectory /grant $Usagers.Nom`:`(OI`)`(CI`)M /t
	icacls $homeDirectory /grant ` 
	"Gestionnaire:(OI)(CI)(RX)" "SYSTEM:(OI)(CI)(F)" "Administrateurs:(OI)(CI)(F)"       
	
	
	New-SmbShare –Name ($Usagers.Nom + "_profil") –Path $profilDirectory  -FullAccess Administrators, System -FolderEnumerationMode AccessBased
	Grant-SmbShareAccess ($Usagers.Nom + "_profil") –AccountName $Usagers.Nom –AccessRight Change
	
}
#Création des dossiers de département

new-item -ItemType directory -Path c:\TEST
new-item -ItemType directory -Path \\Tails\c$\ANALYSE  
new-item -ItemType directory -Path \\Tails\c$\INTEGRATION
new-item -ItemType directory -Path \\Tails\c$\PROGRAMMATION

#Les autorisations des dossiers département

icacls.exe "\\Tails\c$\ANALYSE" /inheritance:r
icacls.exe "\\Tails\c$\ANALYSE" /grant ` 
"Gestionnaire:(OI)(CI)(F)" "SYSTEM:(OI)(CI)(F)" "Administrateurs:(OI)(CI)(F)" "Integrateurs:(OI)(CI)(M)" "Developpeurs_3D:(OI)(CI)(RX)" "DesignerWeb:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)" "Testeur_outils:(OI)(CI)(RX)"


icacls.exe "\\Tails\c$\INTEGRATION" /inheritance:r
icacls.exe "\\Tails\c$\INTEGRATION" /grant ` 
"Gestionnaire:(OI)(CI)(F)" "SYSTEM:(OI)(CI)(F)" "Administrateurs:(OI)(CI)(F)" "DesignerWeb:(OI)(CI)(M)" "Developpeurs_3D:(OI)(CI)(RX)" "Integrateurs:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)" "Testeur_outils:(OI)(CI)(RX)"

icacls.exe "\\Tails\c$\PROGRAMMATION" /inheritance:r
icacls.exe "\\Tails\c$\PROGRAMMATION" /grant ` 
"Gestionnaire:(OI)(CI)(F)" "SYSTEM:(OI)(CI)(F)" "Administrateurs:(OI)(CI)(F)" "Developpeurs_NET:(OI)(CI)(M)" "DesignerWeb:(OI)(CI)(RX)" "Developpeurs_3D:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)" "Testeur_outils:(OI)(CI)(RX)"

icacls.exe "c:\TEST" /inheritance:r
icacls.exe "c:\TEST" /grant ` 
"Gestionnaire:(OI)(CI)(F)" "SYSTEM:(OI)(CI)(F)" "Administrateurs:(OI)(CI)(F)" "Developpeurs_NET:(OI)(CI)(M)" "Developpeurs_3D:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)" "Testeur_outils:(OI)(CI)(RX)" "Integrateurs:(OI)(CI)(RX)"




