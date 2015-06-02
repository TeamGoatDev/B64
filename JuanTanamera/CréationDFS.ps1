###########################################################
# Nom: Jean-William Perreault
# Date: 28 mai 2015
#
# Objectif: 
#    - la création des espaces de noms 
#    - les dossiers sous les espaces de noms
#
# Serveur d'éxécution: SERVEUR 2
# Serveurs modifiés: SERVEUR 2
###########################################################

clear-host


#Install-WindowsFeature FileAndStorage-Services, FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-Con `
#-IncludeManagementTools

New-Item -Path C:\DFSROOT -ItemType Directory -ErrorAction Ignore
New-Item -Path C:\DFSROOT\Dept -ItemType Directory -ErrorAction Ignore
New-Item -Path C:\DFSROOT\Gestionnaire -ItemType Directory -ErrorAction Ignore

$nomServeur1 = "Ganondorf"
$nomServeur2 = "Gerudo"
$c = New-CimSession -ComputerName $nomServeur2;

New-SmbShare -Path C:\DFSROOT\Dept `
				-Name partage_Dept `
				-CachingMode None `
				-FolderEnumerationMode AccessBased `
				-CimSession $c  `


New-SmbShare    -Path  C:\DFSROOT\Gestionnaire `
				-Name partage_Gestionnaire `
				-CachingMode None `
				-FolderEnumerationMode AccessBased `
				-CimSession $c  `


New-DfsnRoot -TargetPath C:\DFSROOT\Dept  `
             -Path \\HYRULE.PRO\DEPT `
             -Type DomainV2 `
             -EnableAccessBasedEnumeration $True


New-DfsnRoot -TargetPath C:\DFSROOT\Gestionnaire  `
             -Path \\HYRULE.PRO\GESTIONNAIRE `
             -Type DomainV2 `
             -EnableAccessBasedEnumeration $True

# DEPT
New-DfsnFolder  -Path \\HYRULE.PRO\DEPT\PROGRAMMATION `
				-TargetPath "\\$nomServeur1\C$\_CEGAT_PRO\PROGRAMMATION"
				
New-DfsnFolder -Path \\HYRULE.PRO\DEPT\INTÉGRATION `
			   -TargetPath "\\$nomServeur1\C$\_CEGAT_PRO\INTÉGRATION"
  
New-DfsnFolder -Path \\HYRULE.PRO\DEPT\ANALYSE `
			   -TargetPath "\\$nomServeur1\C$\_CEGAT_PRO\ANALYSE"
			   
New-DfsnFolder -Path \\HYRULE.PRO\DEPT\TEST `
			   -TargetPath "\\$nomServeur2\C$\_CEGAT_PRO\TEST"



# GESTIONNAIRE
New-DfsnFolder -Path \\HYRULE.PRO\GESTIONNAIRE\PROFILS `
				-TargetPath "\\$nomServeur1\C$\_CEGAT_PRO\Profils"
				
New-DfsnFolder -Path \\HYRULE.PRO\GESTIONNAIRE\PERSO `
			   -TargetPath "\\$nomServeur1\C$\_CEGAT_PRO\Perso"
			   
New-DfsnFolder -Path \\HYRULE.PRO\GESTIONNAIRE\DEPT `
			   -TargetPath "\\$nomServeur1\C$\DFSROOT\Dept"