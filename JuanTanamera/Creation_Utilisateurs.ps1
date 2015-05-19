######################################################
# Nom: Jean-William Perreault
# Date: 14 mai 2015
#
# Objectif: CRÉATION DES UTILISATEURS AD 
#
# Serveur d'éxécution: SERVEUR 1 (Contrôleur de Domaine)
# Serveurs modifiés: SERVEUR 1 (Contrôleur de Domaine)
######################################################



#USERS
$controleurDomaine = "SERVEUR_1"
$csvFileMembres = "\\$controleurDomaine\C$\_CEGAT_PRO\PROG.csv"

$dossiersUtilisateurs = "\\$controleurDomaine\C$\_CEGAT_PRO"
$dossiersPerso = "$dossiersUtilisateurs\Perso"
$dossiersProfils = "$dossiersUtilisateurs\Profils"

$motDePasse = "AAAaaa111"
$lecteurPersonnel = "P"


# CRÉATION DU DOSSIER DES UTILISATEURS
New-Item -Path "C:\_CEGAT_PRO" -ItemType Directory


#LIRE LES UTILISATEURS À PARTIR DU CSV
$csvMembre = Import-Csv -Path $csvFileMembres -Delimiter ";" -Encoding UTF8;

foreach($line in $csvMembre){
    
    $matricule = $line.Matricule

    $nom = $line.Nom
    $prenom = $line.Prenom
    $nomComplet = "$prenom $nom"

    $adresse = $line.Adresse
    $ville = $line.Ville
    $codePostal = $line.CodePostal
    $adresseComplete = "$adresse $ville $codePostal"

    $tel1 = $line.Tel1
    $tel2 = $line.Tel2
    $tel3 = $line.Tel3


    $cheminProfil = "$dossiersProfils\$matricule.V4"

    $dossierPersonnel = "$dossiersPerso\$matricule";

    Write-Host "Ajout de $matricule - $nomComplet ..."


    #Création du dossier personnel + droits NTFS
    Write-Host "Création de son dossier personnel"
    New-Item -Path $dossierPersonnel -ItemType Directory

    icacls $dossierPersonnel  /grant $matricule+":(CI)(OI)(M)"




    #DÉTERMINER LE GROUPE ET LE PATH ACTIVE DIRECTORY
    # Matricule entre 10000 et 19999 = Développeurs 3D
    # Matricule entre 20000 et 29999 = Développeurs .NET
    # Matricule entre 30000 et 39999 = Intégrateurs
    # Matricule entre 40000 et 49999 = Designers WEB
    # Matricule entre 50000 et 59999 = Testeurs d'outils
    # Matricule entre 60000 et 69999 = Testeurs de jeux

    $groupe = ""
    if($matricule -ge 10000 -and $matricule -le 19999){
        $groupe = "Developpeur 3D"
        

    }elseif($matricule -ge 20000 -and $matricule -le 29999){
        $groupe = "Developpeur .NET"

    }elseif($matricule -ge 30000 -and $matricule -le 39999){
        $groupe =  "Integrateurs"

    }elseif($matricule -ge 40000 -and $matricule -le 49999){
        $groupe =  "Designers WEB"

    }elseif($matricule -ge 50000 -and $matricule -le 59999){
        $groupe = "Testeurs d'outils"

    }elseif($matricule -ge 60000 -and $matricule -le 69999){
        $groupe =  "Testeurs de Jeux"
    }





    #CRÉATION DE L'UTILISATEUR DANS L'ACTIVE DIRECTORY
    New-ADUser -Name $matricule `
    -UserPrincipalName $matricule `
    -AccountPassword (ConvertTo-SecureString $motDePasse -AsPlainText -force) `
    -SamAccountName $matricule ` 
    -DisplayName $nomComplet `
    -GivenName $prenom `
    -Surname $nom `
    -OfficePhone  $telDom `
    -OtherAttributes @{"otherTelephone"="$tel1;$tel2"} `
    -StreetAddress $adresse `
    -PostalCode $codePostal `
    -City $ville `
    -ProfilePath $cheminProfil `
    -HomeDrive $lecteurPersonnel `
    -HomeDirectory $dossierPersonnel `
    -Enabled $true `
    -PasswordNeverExpires $true `
    

    Write-Host "$matricule - $nomComplet Ajouté avec succès"
    


    #AJOUT AUX GROUPES
    Add-ADGroupMember $groupe $matricule

    if($matricule % 10000 -eq 0){
        Add-ADGroupMember "Gestionnaires" $matricule
    }
    

}


#NTFS Admin System Gestionnaire

icacls $dossiersPerso  /grant "Administrateurs:(CI)(OI)(F)"
icacls $dossiersPerso  /grant "Systeme:(CI)(OI)(F)"
icacls $dossiersPerso  /grant "Gestionnaire:(CI)(OI)(RX)"

icacls $dossiersProfils  /grant "Administrateurs:(CI)(OI)(F)"
icacls $dossiersProfils  /grant "Systeme:(CI)(OI)(F)"
icacls $dossiersProfils  /grant "Gestionnaire:(CI)(OI)(RX)"