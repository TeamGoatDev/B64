#Antoine Delbast
#Les espaces de noms
#éxécuté sur CD
#modifie le 2 

#variables 

$serveur1 = "Tails"
$serveur2 = "Ruby"
$cheminDfS = "C:\DFSROOT"
$chemin_prog = "\\$serveur1\PROGRAMMATION\"
$chemin_analyse = "\\$serveur1\ANALYSE\"
$chemin_integration = "\\$serveur1\INTEGRATION\"
$chemin_test = "\\$serveur2\TEST\"
$chemin_usagers = "\\$serveur1\_CEGAT_PRO\Usagers"
$chemin_profils = "\\$serveur1\Profils"



#le DFSROOT

New-Item -ItemType directory -Path $cheminDfS -CimSession $serveur2
New-SmbShare –Name "DFS" –Path $cheminDfS  -FullAccess Administrators, System -FolderEnumerationMode AccessBased
Grant-SmbShareAccess "DFS" –AccountName Everyone –AccessRight Read

#la DFS Departementale

$path_dfs_gestionnaires = "C:\DFSROOT\GESTIONNAIRE"

New-Item -ItemType directory -Path $path_dfs_gestionnaires -CimSession $serveur2
New-DfsnRoot -TargetPath "\\$Serveur1\DFS_Gestionnaires" -Type DomainV2 -Path $path_dfs_gestionnaires -EnableAccessBasedEnumeration True -CimSession $serveur2
New-SmbShare –Name "DFS_DEPARTEMENTALE" –Path $path_dfs_gestionnaires  -FullAccess Administrators, System -FolderEnumerationMode AccessBased -CimSession $serveur2

# Ajouter les partages

New-DfsnRootTarget -Path $chemin_prog -TargetPath $path_dfs_gestionnaires -CimSession $serveur2
New-DfsnRootTarget -Path $chemin_test -TargetPath $path_dfs_gestionnaires -CimSession $serveur2
New-DfsnRootTarget -Path $chemin_analyse -TargetPath $path_dfs_gestionnaires -CimSession $serveur2
New-DfsnRootTarget -Path $chemin_integration -TargetPath $path_dfs_gestionnaires -CimSession $serveur2



#la DFS Departementale

$path_dfs_employes = "C:\DFSROOT\EMPLOYE"

New-Item -ItemType directory -Path $path_dfs_employes -CimSession $serveur2
New-DfsnRoot -TargetPath "\\$serveur1\EMPLOYE" -Type DomainV2 -Path $path_dfs_employes -EnableAccessBasedEnumeration True

New-DfsnRootTarget -Path $chemin_usagers  -TargetPath $path_dfs_employes
New-DfsnRootTarget -Path $chemin_profils  -TargetPath $path_dfs_employes
New-DfsnRootTarget -Path $path_dfs_gestionnaires  -TargetPath $path_dfs_employes





