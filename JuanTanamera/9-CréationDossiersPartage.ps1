######################################################
# Nom: Jean-William Perreault
# Date: 28 mai 2015
#
# Objectif: 
# 	- la cr�ation des dossier, 
#	- les autorisations NTFS, 
#	- la cr�ation des partages
#	- les autorisations de partage
#
# Serveur d'�x�cution: SERVEUR 1 (Contr�leur de Domaine)
# Serveurs modifi�s: SERVEUR 1 (Contr�leur de Domaine)
######################################################
clear-host

$nomDomaine = "HYRULE"

$nomServeur1 = "Ganondorf"
$nomServeur2 = "Gerudo"

$dossierPROGRAMMATION = "\\$nomServeur1\C$\_CEGAT_PRO\PROGRAMMATION"
$dossierINTEGRATION = "\\$nomServeur1\C$\_CEGAT_PRO\INT�GRATION"
$dossierANALYSE = "\\$nomServeur1\C$\_CEGAT_PRO\ANALYSE"
$dossierTEST = "\\$nomServeur2\C$\_CEGAT_PRO\TEST"

##
# Attribut les droits aux gestionnaires
# enl�ve les droits aux Utilisateurs, Utilisateurs authentifi�s, 
# Utilisateurs du domaine
# @param: dossier � modifier
##
function NTFSGeneral($dossier){

	icacls  $dossier  /grant "HYRULE\Gestionnaires:(CI)(OI)(F)"
	icacls  $dossier  /grant "HYRULE\Admins du domaine:(CI)(OI)(F)"
	icacls  $dossier  /remove "HYRULE\Utilisateurs" /T
	icacls  $dossier  /remove "HYRULE\Utilisateurs authentifi�s" /T
	icacls  $dossier  /remove "HYRULE\Utilisateurs du domaine" /T
}

##
# Cr�� un nouveau partage selon 
# les param�tres sp�cifi�s
# @param: serveur - Le nom du serveur cible
# @param: chemin - � partir du C (Le lecteur C est implied)
##
function nouveauPartage($serveur, $nomPartage, $cheminPartage){
	#Remote Session
	$c = New-CimSession -ComputerName $serveur;

    # On essaie de le supprimer s'il est d�j� existant
    #Remove-SmbShare -Name $nomPartage -CimSession $c;
    
	#CR�ATION DU PARTAGE
	Write-Host "Creation du partage $nomPartage sur $serveur ..."
	New-SmbShare -Path $cheminPartage `
				-Name $nomPartage `
				-CachingMode None `
				-FolderEnumerationMode AccessBased `
				-CimSession $c  `

	Write-Host "Creation du partage $nomPartage sur $serveur R�USSIE " -ForegroundColor Green
}



# MAIN SCRIPT #

#Cr�ation des dossiers
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
icacls  $dossierANALYSE  /grant "HYRULE\Int�grateurs:(CI)(OI)(M)"
icacls  $dossierANALYSE  /grant "HYRULE\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "HYRULE\Designers WEB:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "HYRULE\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierANALYSE  /grant "HYRULE\Testeurs de Jeux:(CI)(OI)(RX)"

#autorisations INT�GRATION
icacls  $dossierINTEGRATION  /grant "HYRULE\Designers WEB:(CI)(OI)(M)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Developpeurs 3D:(CI)(OI)(RX)"
icacls  $dossierINTEGRATION  /grant "HYRULE\Int�grateurs:(CI)(OI)(RX)"
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
icacls  $dossierTEST  /grant "HYRULE\Int�grateurs:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "HYRULE\Testeurs d'outils:(CI)(OI)(RX)"
icacls  $dossierTEST  /grant "HYRULE\Testeurs de Jeux:(CI)(OI)(RX)"


#Cr�ation des Partages
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_PROGRAMMATION" -cheminPartage C:\_CEGAT_PRO\PROGRAMMATION
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_INTEGRATION" -cheminPartage C:\_CEGAT_PRO\INTEGRATION
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_ANALYSE" -cheminPartage C:\_CEGAT_PRO\ANALYSE
nouveauPartage -serveur $nomServeur1 -nomPartage "partage_TEST" -cheminPartage C:\_CEGAT_PRO\TEST


