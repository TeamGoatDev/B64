

clear-host

#USERS
$controleurDomaine = "AXE"
$csvFileMembres = "\\$controleurDomaine\C$\B64\Arnaud\B64\PROG.csv"

$dossiersUtilisateurs = "\\$controleurDomaine\C$\_CEGAT_PRO"
$dossiersPerso = "$dossiersUtilisateurs\_Perso"
$dossiersProfils = "$dossiersUtilisateurs\_Profiles"

$motDePasse = "AAAaaa111"

#Dossier contenant les profiles
New-Item -path C:\_CEGAT_PRO -name "_Profiles" -type directory;

#Dossier contenant les perso
New-Item -path C:\_CEGAT_PRO -name "_Perso" -type directory;

$cim = New-CimSession -ComputerName AXE;

New-SmbShare -Name Perso$ `
            -Path C:\_CEGAT_PRO\_Perso `
            -CimSession $cim `
            -FolderEnumerationMode AccessBased `
            -CachingMode None;
			  
New-SmbShare -Name Profiles$ `
              -Path C:\_CEGAT_PRO\_Profiles `
              -CimSession $cim `
              -FolderEnumerationMode AccessBased `
              -CachingMode None;

$DC = (Get-ADDomain).DistinguishedName
$PROG = (Get-ADOrganizationalUnit  -Filter: 'Name -eq "PROGRAMMATION"').DistinguishedName

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

    $dossierPersonnel = "\\AXE\Perso$\$matricule";

    Write-Host "Ajout de $matricule - $nomComplet ..."


    #Création du dossier personnel + dossier Profil
    Write-Host "Création de son dossier personnel"
    New-Item -Path $dossierPersonnel -ItemType Directory
    New-Item -Path $cheminProfil -ItemType Directory
 


    #DÉTERMINER LE GROUPE ET LE PATH ACTIVE DIRECTORY
    # Matricule entre 10000 et 19999 = Développeurs 3D
    # Matricule entre 20000 et 29999 = Développeurs .NET
    # Matricule entre 30000 et 39999 = Intégrateurs
    # Matricule entre 40000 et 49999 = Designers WEB
    # Matricule entre 50000 et 59999 = Testeurs d'outils
    # Matricule entre 60000 et 69999 = Testeurs de jeux

    $groupe = ""
    $ouName = ""


    if($matricule -ge 10000 -and $matricule -le 19999){
        $groupe = "Developpeurs 3D"
        $ouName = "3D"

    }elseif($matricule -ge 20000 -and $matricule -le 29999){
        $groupe = "Developpeurs .NET"
        $ouName = "NET"

    }elseif($matricule -ge 30000 -and $matricule -le 39999){
        $groupe =  "Integrateurs"
        $ouName = "Integration"
    }
    elseif($matricule -ge 40000 -and $matricule -le 49999){
        $groupe =  "Designeurs"
        $ouName = "Design"

    }elseif($matricule -ge 50000 -and $matricule -le 59999){
        $groupe = "Testeurs Outils"
        $ouName = "Outils"

    }elseif($matricule -ge 60000 -and $matricule -le 69999){
        $groupe =  "Testeurs Jeux"
        $ouName = "Jeux"
    }

    $userPath = (Get-ADOrganizationalUnit  -Filter: 'Name -eq $ouName').DistinguishedName


    #CRÉATION DE L'UTILISATEUR DANS L'ACTIVE DIRECTORY
    New-ADUser -Name $matricule `
    -UserPrincipalName "$matricule@DOTA.PRO" `
    -AccountPassword (ConvertTo-SecureString $motDePasse -AsPlainText -force) `
    -DisplayName $nomComplet `
    -HomePhone $telDom `
    -GivenName $prenom `
    -Surname $nom `
    -OfficePhone $tel1 `
    -OtherAttributes @{"otherTelephone"="$tel2;$tel3"} `
    -StreetAddress $adresse `
    -PostalCode $codePostal `
    -City $ville `
    -ProfilePath $cheminProfil `
    -HomeDrive "P:" `
    -HomeDirectory $dossierPersonnel `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -Path $userPath
    

    Write-Host "$matricule - $nomComplet Ajouté avec succès"
    
    

    #AJOUT AUX GROUPES

    Add-ADGroupMember $groupe $matricule

    if($matricule % 10000 -eq 0){
        Add-ADGroupMember "Gestionnaires" $matricule
    }
    

    #DROITS NTFS SUR DOSSIER PERSO
    icacls $dossierPersonnel  /grant $matricule":(CI)(OI)(M)"

}


#NTFS Admin System Gestionnaire

icacls $dossiersPerso  /grant "DOTA\Admins du domaine:(CI)(OI)(F)"
icacls $dossiersPerso  /grant "Système:(CI)(OI)(F)"
icacls $dossiersPerso  /grant "DOTA\Gestionnaires:(CI)(OI)(RX)"

icacls $dossiersProfils  /grant "DOTA\Admins du domaine:(CI)(OI)(F)"
icacls $dossiersProfils  /grant "Système:(CI)(OI)(F)"
icacls $dossiersProfils  /grant "DOTA\Gestionnaires:(CI)(OI)(RX)"