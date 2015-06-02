######################################################
# Nom: Jean-William Perreault
# Date: 28 mai 2015
#
# Objectif: 
# 	- la création des dossier, 
#	- les autorisations NTFS, 
#	- la création des partages
#	- les autorisations de partage
#
# Serveur d'éxécution: SERVEUR 1 (Contrôleur de Domaine)
# Serveurs modifiés: SERVEUR 1 (Contrôleur de Domaine)
######################################################
clear-host

$nomDomaine = "HYRULE"

$nomServeur1 = "Ganondorf"
$nomServeur2 = "Gerudo"

$dossierPROGRAMMATION = "\\$nomServeur1\C$\_CEGAT_PRO\PROGRAMMATION"
$dossierINTEGRATION = "\\$nomServeur1\C$\_CEGAT_PRO\INTÉGRATION"
$dossierANALYSE = "\\$nomServeur1\C$\_CEGAT_PRO\ANALYSE"
$dossierTEST = "\\$nomServeur2\C$\_CEGAT_PRO\TEST"

##
# Attribut les droits aux gestionnaires
# enlève les droits aux Utilisateurs, Utilisateurs authentifiés, 
# Utilisateurs du domaine
# @param: dossier à modifier
##
function NTFSGeneral($dossier){

	icacls  $dossier  /grant "HYRULE\Gestionnaires:(CI)(OI)(F)"
	icacls  $dossier  /grant "HYRULE\Admins du domaine:(CI)(OI)(F)"
	icacls  $dossier  /remove "HYRULE\Utilisateurs" /T
	icacls  $dossier  /remove "HYRULE\Utilisateurs authentifiés" /T
	icacls  $dossier  /remove "HYRULE\Utilisateurs du domaine" /T
}

##
# Créé un nouveau partage selon 
# les paramètres spécifiés
# @param: serveur - Le nom du serveur cible
# @param: chemin - à partir du C (Le lecteur C est implied)
##
function nouveauPartage($serveur, $nomPartage, $cheminPartage){
	#Remote Session
	$c = New-CimSession -ComputerName $serveur;

    # On essaie de le supprimer s'il est déjà existant
    #Remove-SmbShare -Name $nomPartage -CimSession $c;
    
	#CRÉATION DU PARTAGE
	Write-Host "Creation du partage $nomPartage sur $serveur ..."
	New-SmbShare -Path $cheminPartage `
				-Name $nomPartage `
				-CachingMode None `
				-FolderEnumerationMode AccessBased `
				-CimSession $c  `

	Write-Host "Creation du partage $nomPartage sur $serveur RÉUSSIE " -ForegroundColor Green
}



# MAIN SCRIPT #

#Création des dossiers
New-Item -path $dossierPROGRAMMATION -ItemType Directory
New-Item -path $dossierINTEGRATION  -ItemType Directory
New-Item -path $dossierANALYSE -ItemType Directory
New-Item -path $dossierTEST -ItemType Directory

#Autorisations
NTFSGeneral($dossierPROGRAMMATION)
NTFSGeneral($dossierINTEGRATION)
NTFSGeneral($dossierANALYSE)
NTFSGeneral($dossierTEST)

#autorisations ANALYSE
icacls  $dossierANALYSE  /grant "HYRULE\Intégrateurs:(CI)(OI)(M)"
icacls  $dossierANALYSE  /grant "HYRULE\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "HYRULE\Designers WEB:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "HYRULE\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "HYRULE\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations INTÉGRATION
icacls  $dossierINTEGRATION  /grant "HYRULE\Designers WEB:(CI)(OI)(M)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Intégrateurs:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations PROGRAMMATION
icacls  $dossierINTEGRATION  /grant "HYRULE\Developpeurs .NET:(CI)(OI)(M)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Designers WEB:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations TEST
icacls  $dossierTEST  /grant "HYRULE\Developpeurs .NET:(CI)(OI)(M)"
icacls  $dossierTEST  /grant "HYRULE\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "HYRULE\Intégrateurs:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "HYRULE\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "HYRULE\Testeurs de Jeux:(CI)(OI)(RX)"


#Création des Partages
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_PROGRAMMATION" -cheminPartage C:\_CEGAT_PRO\PROGRAMMATION
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_INTEGRATION" -cheminPartage C:\_CEGAT_PRO\INTEGRATION
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_ANALYSE" -cheminPartage C:\_CEGAT_PRO\ANALYSE
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_TEST" -cheminPartage C:\_CEGAT_PRO\TEST


