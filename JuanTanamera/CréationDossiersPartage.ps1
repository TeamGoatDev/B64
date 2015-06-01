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

$nomDomaine = "HYRULE.PRO"

$nomServeur1 = "Gerudo"
$nomServeur2 = "Ganondorf"

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

	icacls  $dossier  /grant "$nomDomaine\Gestionnaires:(CI)(OI)(F)"
	icacls  $dossier  /grant "$nomDomaine\Administrateurs:(CI)(OI)(F)"
	icacls  $dossier  /remove "$nomDomaine\Utilisateurs" /T
	icacls  $dossier  /remove "$nomDomaine\Utilisateurs authentifiés" /T
	icacls  $dossier  /remove "$nomDomaine\Utilisateurs du domaine" /T
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
    Remove-SmbShare -Name $nomPartage -CimSession $c;
    
	#CRÉATION DU PARTAGE
	Write-Host "Creation du partage $nomPartage sur $serveur ..."
	New-SmbShare -Path $cheminPartage `
				-Name $nomPartage `
				-CachingMode None `
				-FolderEnumerationMode AccessBased
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
icacls  $dossierANALYSE  /grant "$nomDomaine\Intégrateurs:(CI)(OI)(M)"
icacls  $dossierANALYSE  /grant "$nomDomaine\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "$nomDomaine\Designers WEB:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "$nomDomaine\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "$nomDomaine\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations INTÉGRATION
icacls  $dossierINTEGRATION  /grant "$nomDomaine\Designers WEB:(CI)(OI)(M)"
icacls  $dossierINTEGRATION  /grant "$nomDomaine\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "$nomDomaine\Intégrateurs:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "$nomDomaine\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "$nomDomaine\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations PROGRAMMATION
icacls  $dossierPROGRAMMATION  /grant "$nomDomaine\Designers .NET:(CI)(OI)(M)"
icacls  $dossierPROGRAMMATION  /grant "$nomDomaine\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierPROGRAMMATION  /grant "$nomDomaine\Designers WEB:(CI)(OI)(RX)"
icacls  $dossierPROGRAMMATION  /grant "$nomDomaine\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierPROGRAMMATION  /grant "$nomDomaine\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations TEST
icacls  $dossierTEST  /grant "$nomDomaine\Designers .NET:(CI)(OI)(M)"
icacls  $dossierTEST  /grant "$nomDomaine\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "$nomDomaine\Intégrateurs:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "$nomDomaine\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "$nomDomaine\Testeurs de Jeux:(CI)(OI)(RX)"


#Création des Partages
nouveauPartage -serveur $serveur1 -nomPartage "partage_PROGRAMMATION" -cheminPartage $dossierPROGRAMMATION
nouveauPartage -serveur $serveur1 -nomPartage "partage_INTEGRATION" -cheminPartage $dossierINTEGRATION
nouveauPartage -serveur $serveur1 -nomPartage "partage_ANALYSE" -cheminPartage $dossierANALYSE
nouveauPartage -serveur $serveur1 -nomPartage "partage_TEST" -cheminPartage $dossierTEST


