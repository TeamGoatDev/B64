#SETUP GPO

clear-host
import-module grouppolicy

Backup-GPO -Name DOMAINE_SECURITE -Path "C:\GPOBackup"
Backup-GPO -Name DOMAINE_OUVERTURE -Path "C:\GPOBackup"
Backup-GPO -Name DOMAINE_FERMETURE -Path "C:\GPOBackup"
Backup-GPO -Name DOMAINE_ORDI -Path "C:\GPOBackup"
Backup-GPO -Name GPO_USERS -Path "C:\GPOBackup"


#Import-GPO -BackupGPOName DOMAINE_FERMETURE -CreateIfNeeded -Path "C:\GPOBackup" -TargetName DOMAINE_FERMETURE
#Import-GPO -BackupGPOName DOMAINE_OUVERTURE -CreateIfNeeded -Path "C:\GPOBackup" -TargetName DOMAINE_OUVERTURE
#Import-GPO -BackupGPOName DOMAINE_SECURITE -CreateIfNeeded -Path "C:\GPOBackup" -TargetName DOMAINE_SECURITE

