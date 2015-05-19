#SETUP GPO


$domaineOuverture = "DOMAINE_OUVERTURE"
$domaineFermeture = "DOMAINE_FERMETURE"
$domaineSecurite = "DOMAINE_SECURITE"



import-module –Name grouppolicy


#DOMAINE OUVERTURE
Write-Host "Création de la GPO $domaineOuverture"
New-GPO -Name $domaineOuverture

#-- attendre reseau (démarrage ordi + ouverture session)
Set-GPRegistryValue -Name $domaineOuverture "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName SyncForegroundPolicy -V
#--Définir l'intervalle d'actualisation de la stratégie de groupe pour les contrôleurs de domaine
#--Définir l'intervalle d'actualisation de la stratégie de groupe pour les ordinateurs



#DOMAINE FERMETURE
Write-Host "Création de la GPO $domaineFermeture"
New-GPO -Name $domaineFermeture

#DÉSACTIVER LE PARAMÈTRE Afficher le moniteur d’évènements de mise hors tension


#ACTIVER LE PARAMÈTRE Arrêt: permet au système d’être arrêté sans avoir à se connecter





#DOMAINE SECURITE
New-GPO -Name $domaineSecurite