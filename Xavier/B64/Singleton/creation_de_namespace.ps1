#Xavier Hudon-Dansereau
#28/05/2015
#Script #1
#Lancer à partir du serveur InterneDeux
#Ce code modifie les configurations du serveur InterneDeux
#------------------------------------------------------
#Déclaration
#------------$v1Name = "InterneUn";
$v2Name = "InterneDeux";$cim = New-CimSession -ComputerName $serveur;$domaine = "CEGAT.PRO"
#------------#
#Création    #
#------------#New-Item -Path \\$v2Name\C$\dfs\Departement -ItemType directory -ForceNew-Item -Path \\$v2Name\C$\dfs\Gestionnaire -ItemType directory -Force

#------------#
#Share       #
#------------#New-SmbShare -Name DEPARTEMENT$ `    -FullAccess "Tout le monde" `    -Path C:\dfs\Departement `    -CimSession $cim `    -FolderEnumerationMode AccessBased `    -CachingMode NoneNew-SmbShare -Name GESTIONNAIRE$ `    -FullAccess "Tout le monde" `    -Path C:\dfs\Gestionnaire `    -CimSession $cim `    -FolderEnumerationMode AccessBased `    -CachingMode None#--------------#
#NameSpace Root#
#--------------#New-DfsnRoot -Path "\\$domaine\dfs\Departement" `    -TargetPath "\\$v1Name\DEPARTEMENT$" `    -Type DomainV1`    -EnableAccessBasedEnumeration $true;New-DfsnRoot -Path "\\$domaine\dfs\Gestionnaire" `    -TargetPath "\\$v1Name\GESTIONNAIRE$" `    -Type DomainV1`    -EnableAccessBasedEnumeration $true;#------------#
#Département #
#------------#New-DfsnFolder -Path "\\$domaine\Departement\Analyse" `    -TargetPath "\\$v1Name\ANALYSE";New-DfsnFolder -Path "\\$domaine\Departement\Integration" `-TargetPath "\\$v1Name\INTEGRATION";New-DfsnFolder -Path "\\$domaine\Departement\Programmation" `    -TargetPath "\\$v1Name\PROGRAMMATION";New-DfsnFolder -Path "\\$domaine\Departement\Test" `    -TargetPath "\\$v2Name\TEST";#------------#
#Gestionnaire#
#------------#New-DfsnFolder -Path "\\$domaine\Gestionnaire\Perso" `    -TargetPath "\\$v1Name\Perso$";New-DfsnFolder -Path "\\$domaine\Gestionnaire\Profiles" `    -TargetPath "\\$v1Name\Profiles$";New-DfsnFolder -Path "\\$domaine\Gestionnaire\Dep" `    -TargetPath "\\$v1Name\DEPARTEMENT$";