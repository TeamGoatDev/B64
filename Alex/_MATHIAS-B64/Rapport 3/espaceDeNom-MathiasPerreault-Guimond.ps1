#Mathias Perreault-Guimond
#28 mai 2015
#Création des espaces de nom
#Exécuté à partir du Serveur 2
#Le serveur 2 sera modifié

New-Item -Path C:\DFSROOT -ItemType Directory
New-Item -Path C:\DFSROOT\DFSdepartement -ItemType Directory
New-Item -Path C:\DFSROOT\DFSgestionnaire -ItemType Directory

New-SmbShare -Name DFSDept -Path C:\DFSROOT\DFSdepartement `
-FullAccess "Tout le monde" -FolderEnumerationMode AccessBased
New-SmbShare -Name DFSGestion -Path C:\DFSROOT\DFSgestionnaire `
-FullAccess "Tout le monde" -FolderEnumerationMode AccessBased

New-DfsnRoot -Path \\CEGAT.PRO\DFSdepartement `
-TargetPath \\SERVEUR_2\DFSDept `
-Type DomainV2 `
-EnableAccessBasedEnumeration $true

New-DfsnFolder -Path \\CEGAT.PRO\DFSdepartement\PROGRAMMATION `
-TargetPath \\SERVEUR_1\C$\_CEGAT_PRO\PROGRAMMATION

New-DfsnFolder -Path \\CEGAT.PRO\DFSdepartement\ANALYSE `
-TargetPath \\SERVEUR_1\C$\_CEGAT_PRO\ANALYSE

New-DfsnFolder -Path \\CEGAT.PRO\DFSdepartement\INTEGRATION `
-TargetPath \\SERVEUR_1\C$\_CEGAT_PRO\INTEGRATION

New-DfsnFolder -Path \\CEGAT.PRO\DFSdepartement\TEST `
-TargetPath \\SERVEUR_2\C$\_CEGAT_PRO\TEST






New-DfsnRoot -Path \\CEGAT.PRO\DFSgestionnaire `
-TargetPath \\SERVEUR_2\DFSGestion `
-Type DomainV2 `
-EnableAccessBasedEnumeration $true

New-DfsnFolder -Path \\CEGAT.PRO\DFSgestionnaire\PERSO `
-TargetPath \\SERVEUR_1\C$\_CEGAT_PRO\PERSO

New-DfsnFolder -Path \\CEGAT.PRO\DFSgestionnaire\PROFIL `
-TargetPath \\SERVEUR_1\C$\_CEGAT_PRO\PROFIL

New-DfsnFolder -Path \\CEGAT.PRO\DFSgestionnaire\DEPT `
-TargetPath \\CEGAT.PRO\DFSdepartement