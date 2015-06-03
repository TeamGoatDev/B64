#Mathias Perreault-Guimond
#25 mai 2015
#Création des dossiers et partages
#Exécuté à partir du Serveur 2
#Le serveur 1 et le serveur 2 seront modifiés

#fichier CSV
$fCsv = "C:\_cours\PROG.csv"

New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO -ItemType directory
icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO" /inheritance:r
icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO" /grant "Administrateurs:(OI)(CI)(F)" `
"SYSTEM:(OI)(CI)(F)" "Gestionnaire:(OI)(CI)(RX)"
#Dossier utilisateurs
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\PERSO -ItemType directory
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\PROFIL -ItemType directory

#Dossier département
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\PROGRAMMATION -ItemType directory
New-Item -Path C:\_CEGAT_PRO\TEST -ItemType directory
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\ANALYSE -ItemType directory
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\INTEGRATION -ItemType directory

#Autorisations pour les dossiers département
icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO\PROGRAMMATION" /grant `
"Gestionnaire:(OI)(CI)(F)" "Developpeurs_NET:(OI)(CI)(M)" `
"DesignerWeb:(OI)(CI)(RX)" "Developpeurs_3D:(OI)(CI)(RX)" `
"Testeur_outils:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)"

icacls.exe "C:\_CEGAT_PRO\TEST" /grant "Gestionnaire:(OI)(CI)(F)" `
"Developpeurs_NET:(OI)(CI)(M)" "Integrateur:(OI)(CI)(RX)" `
"Developpeurs_3D:(OI)(CI)(RX)" "Testeur_outils:(OI)(CI)(RX)" `
"Testeur_jeux:(OI)(CI)(RX)"

icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO\ANALYSE" /grant `
"Gestionnaire:(OI)(CI)(F)" "Integrateur:(OI)(CI)(M)" `
"DesignerWeb:(OI)(CI)(RX)" "Developpeurs_3D:(OI)(CI)(RX)" `
"Testeur_outils:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)"

icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO\INTEGRATION" /grant `
"Gestionnaire:(OI)(CI)(F)" "DesignerWeb:(OI)(CI)(M)" `
"Integrateur:(OI)(CI)(RX)" "Developpeurs_3D:(OI)(CI)(RX)" `
"Testeur_outils:(OI)(CI)(RX)" "Testeur_jeux:(OI)(CI)(RX)"

#Partage utilisateurs
New-SmbShare -Name PERSO -Path "C:\_CEGAT_PRO\PERSO" -CachingMode None `
-CimSession SERVEUR_1 -FullAccess "Tout le monde" `
-FolderEnumerationMode AccessBased
New-SmbShare -Name PROFIL -Path "C:\_CEGAT_PRO\PROFIL" -CachingMode None `
-CimSession SERVEUR_1 -FullAccess "Tout le monde" `
-FolderEnumerationMode AccessBased

#Partage département
New-SmbShare -Name PROG -Path "C:\_CEGAT_PRO\PROGRAMMATION" -CachingMode None `
-CimSession SERVEUR1 -FullAccess "Tout le monde" `
-FolderEnumerationMode AccessBased
New-SmbShare -Name TEST -Path "C:\_CEGAT_PRO\TEST" -CachingMode None `
-FullAccess "Tout le monde" -FolderEnumerationMode AccessBased
New-SmbShare -Name ANALYSE -Path "C:\_CEGAT_PRO\ANALYSE" -CachingMode None `
-CimSession SERVEUR1 -FullAccess "Tout le monde" `
-FolderEnumerationMode AccessBased
New-SmbShare -Name INTEGRATION -Path "C:\_CEGAT_PRO\INTEGRATION" `
-CachingMode None -CimSession SERVEUR1 -FullAccess "Tout le monde" `
-FolderEnumerationMode AccessBased

$csv = Import-Csv -path $fCsv -delimiter ";" -encoding default

#Foreach dans le csv
foreach($line in $csv) {

$matricule = $line.Matricule
#Dossier perso
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\PERSO\$matricule -ItemType directory
icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO\PERSO\$matricule" /grant $matricule':(OI)(CI)(M)'
#Dossiper profil
New-Item -Path \\SERVEUR1\C$\_CEGAT_PRO\PROFIL\$matricule.V4 -ItemType directory
icacls.exe "\\SERVEUR1\C$\_CEGAT_PRO\PROFIL\$matricule.V4" /grant $matricule':(OI)(CI)(M)'

Set-ADUser -Identity $matricule -HomeDrive P: -HomeDirectory "\\SERVEUR1\PERSO\$matricule" `
-ProfilePath "\\SERVEUR1\PROFIL\$matricule"

}