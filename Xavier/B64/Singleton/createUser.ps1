#Xavier Hudon-Dansereau
#Création des users
#Lancer ce scipt sur InterneUn

#Nom du fichier de données
$filePath = "PROG.csv"
$oCsv = Import-Csv -path $filePath -Delimiter ";"
$nomDom = "OU=Programmation,DC=CEGAT,DC=PRO"
$nomDNS = (Get-ADDomain).DNSRoot
$mdp = "AAAaaa111"
$lesGroupes = @(
        "Développeur .NET",
        "Dévelopeur 3D",
        "Intégrateurs",
        "Designers WEB",
        "Testeurs d'outils",
        "Testeurs de jeux",
        "Gestionnaires"
        )
New-Item -Path "C:\_CEGAT_PRO\_Profiles" -ItemType directory -Force
New-Item -Path "C:\_CEGAT_PRO\_Perso" -ItemType directory -Force

Foreach ($Ligne in $oCsv)
{
    $Matricule = $Ligne.Matricule
    $Nom = $Ligne.Nom
    $Prenom = $Ligne.Prenom
    $Adresse = $Ligne.Adresse
    $Ville = $Ligne.Ville
    $CodePostal = $Ligne.CodePostal
    $Tel1 = $Ligne.Tel1
    $Tel2 = $Ligne.Tel2
    $Tel3 = $Ligne.Tel3
    

    if([int]$Matricule -ge 10000 -and [int]$Matricule -le 19999){
        $Path = "OU=3D,OU=Dev,$nomDom"
        $AdGroup = $lesGroupes[0]
        addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup)
    }
    elif([int]$Matricule -ge 20000 -and [int]$Matricule -le 29999){
        $Path = "OU=dotNET,OU=Dev,$nomDom"
        $AdGroup = $lesGroupes[1]
        addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup)
    }
    elif([int]$Matricule -ge 30000 -and [int]$Matricule -le 39999){
        $Path = "OU=Intergrateurs,$nomDom"
        $AdGroup = $lesGroupes[2]
        addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup)
    }
    elif([int]$Matricule -ge 40000 -and [int]$Matricule -le 49999){
        $Path = "OU=Designers,$nomDom"
        $AdGroup = $lesGroupes[3]
        addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup)
    }
    elif([int]$Matricule -ge 50000 -and [int]$Matricule -le 59999){
        $Path = "OU=Outils,OU=Test,$nomDom"
        $AdGroup = $lesGroupes[4]
        addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup)
    }
    elif([int]$Matricule -ge 60000 -and [int]$Matricule -le 69999){
        $Path = "OU=Jeux,OU=Test,$nomDom"
        $AdGroup = $lesGroupes[5]
        addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup)
    }
    #Section gestionnaire
    if([int]$Matricule -eq 10000 `
    -or[int]$Matricule -eq 20000 `
    -or[int]$Matricule -eq 30000 `
    -or[int]$Matricule -eq 40000 `
    -or[int]$Matricule -eq 50000 `
    -or[int]$Matricule -eq 60000 ){
        Add-AdGroupMember $lesGroupes[6] $Matricule
    }
    icacls "C:\_Profiles\$Matricule" /inheritance:r
    icacls "C:\_Profiles\$Matricule" /grant "Administrateurs:(CI)(OI)(F)"
    icacls "C:\_Profiles\$Matricule" /grant "Système:(CI)(OI)(F)"
    icacls "C:\_Profiles\$Matricule" /grant "Gestionnaires:(CI)(OI)RX"
    icacls "C:\_Profiles\$Matricule" /grant "${Matricule}:(CI)(OI)M"

    icacls "C:\_Perso\$Matricule" /inheritance:r
    icacls "C:\_Perso\$Matricule" /grant "Administrateurs:(CI)(OI)(F)"
    icacls "C:\_Perso\$Matricule" /grant "Système:(CI)(OI)(F)"
    icacls "C:\_Perso\$Matricule" /grant "Gestionnaires:(CI)(OI)RX"
    icacls "C:\_Perso\$Matricule" /grant "${Matricule}:(CI)(OI)M"
}

function addUser($Matricule, $Nom, $Prenom, $Adresse, $Ville,`
                            $CodePostal, $Tel1, $Tel2, $Tel3, $Path, $AdGroup){
    
    New-ADUser -Name $Matricule `
	    -UserPrincipalName "$Matricule" `
	    -GivenName $Nom `
	    -Surname $Prenom `
	    -DisplayName "$Prenom $Nom" `
	    -StreetAddress $Addresse `
        -City $Ville `
        -PostalCode $CodePostal `
	    -OfficePhone $Tel1 `
	    -OtherAttributes @{'otherTelephone'="$Tel2;$Tel3" } `
        -Path $NomDNS `
        -ProfilePath "C:\_Profiles\$Matricule" `
        -HomeDrive "C:\" `
        -HomeDirectory "\\CEGAT\_Perso\Matricule" `
	    -AccountPassword (ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force) `
	    -PasswordNeverExpires $true `
	    -Enabled $true

    Add-ADGroupMember $AdGroup $Matricule

    New-Item -Path "C:\_CEGAT_PRO\_Profiles\$matricule" -ItemType directory -Force
    New-Item -Path "C:\_CEGAT_PRO\_Perso\$matricule" -ItemType directory -Force

}