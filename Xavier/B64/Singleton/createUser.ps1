#Xavier Hudon-Dansereau
#Création des users
#Lancer ce script sur InterneUn

#--------------#
#Déclaration   #
#--------------#
$filePath = "PROG.csv"
$oCsv = Import-Csv -path $filePath -Delimiter ";"
$nomDom = "OU=Programmation,DC=CEGAT,DC=PRO"
$nomDNS = (Get-ADDomain).DNSRoot
$cim = New-CimSession -ComputerName InterneUn;
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

#--------------#
#Creation      #
#--------------#
New-Item -Path "C:\_CEGAT_PRO\_Profiles" -ItemType directory -Force
New-Item -Path "C:\_CEGAT_PRO\_Perso" -ItemType directory -Force

 New-SmbShare -Name Perso$ `
              -Path C:\_CEGAT_PRO\_Perso `
              -CimSession $cim `
              -FolderEnumerationMode AccessBased `
              -CachingMode None
			  
New-SmbShare -Name Profiles$ `
              -Path C:\_CEGAT_PRO\_Profiles `
              -CimSession $cim `
              -FolderEnumerationMode AccessBased `
              -CachingMode None

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
    $AdGroup = ""
    $Path = ""

    if([int]$Matricule -ge 10000 -and [int]$Matricule -le 19999){
        $Path = "OU=3D,OU=Dev,$nomDom"
        $AdGroup = $lesGroupes[0]
    }
    elif([int]$Matricule -ge 20000 -and [int]$Matricule -le 29999){
        $Path = "OU=dotNET,OU=Dev,$nomDom"
        $AdGroup = $lesGroupes[1]
    }
    elif([int]$Matricule -ge 30000 -and [int]$Matricule -le 39999){
        $Path = "OU=Intergrateurs,$nomDom"
        $AdGroup = $lesGroupes[2]
    }
    elif([int]$Matricule -ge 40000 -and [int]$Matricule -le 49999){
        $Path = "OU=Designers,$nomDom"
        $AdGroup = $lesGroupes[3]
    }
    elif([int]$Matricule -ge 50000 -and [int]$Matricule -le 59999){
        $Path = "OU=Outils,OU=Test,$nomDom"
        $AdGroup = $lesGroupes[4]
    }
    elif([int]$Matricule -ge 60000 -and [int]$Matricule -le 69999){
        $Path = "OU=Jeux,OU=Test,$nomDom"
        $AdGroup = $lesGroupes[5]
    }
    addUser $Matricule $Nom $Prenom $Adresse $Ville $CodePostal $Tel1 $Tel2 $Tel3 $Path $AdGroup

    #Section gestionnaire
    if([int]$Matricule % 10000 -eq 0){
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

    New-Item -Path "C:\_CEGAT_PRO\_Profiles\$matricule" -ItemType directory -Force
    New-Item -Path "C:\_CEGAT_PRO\_Perso\$matricule" -ItemType directory -Force

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
        -Path $Path `
        -ProfilePath "C:\_CEGAT_PRO\_Profiles\$Matricule.V4" `
        -HomeDrive "C:\" `
        -HomeDirectory "\\InterneUn\_CEGAT_PRO\_Perso\$Matricule" `
	    -AccountPassword (ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force) `
	    -PasswordNeverExpires $true `
	    -Enabled $true

    Add-ADGroupMember $AdGroup $Matricule
}