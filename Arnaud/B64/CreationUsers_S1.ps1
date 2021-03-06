#Nom : Arnaud Girardin
#Date : 2015-05-11
#Description : Creation des Utilisateurs
#Source : Serveur 1 (AXE)
#Modifications : Serveur 1 (AXE)

#Path du csv
$path = "C:\Users\REKT\Desktop\PROG.csv";

$parent = "OU=Programmation,DC=DOTA,DC=PRO";

$password = "AAAaaa111";

#Creation de la collection d'objets
$csv = Import-Csv -path $path -Delimiter ";";

New-Item -path C:\ -name "_CEGAT_PRO" -type directory;

#Dossier contenant les profiles
New-Item -path C:\_CEGAT_PRO -name "_Profiles" -type directory;

#Dossier contenant les perso
New-Item -path C:\_CEGAT_PRO -name "_Perso" -type directory;

$cim = New-CimSession -ComputerName AXE;

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

foreach($line in $csv)
{
    $matricule = $line.Matricule;
    $nom = $line.Nom;
    $prenom = $line.Prenom;
    $adresse = $line.Adresse;
    $ville = $line.Ville;
    $postal = $line.CodePostal;
    $tel1 = $line.Tel1;
    $tel2 = $line.Tel2;
    $tel3 = $line.Tel3;

    #Write-Host "Création du groupe " $matricule $nom $prenom $adresse $ville $postal $tel1 $tel2 $tel3;

    #Creation du dossier profil pour l'utilisateur
    New-Item -path "C:\_CEGAT_PRO\_Profiles" -name $matricule -type directory;
    
    #Creation du dossier Personnel pour l'utilisateur
    New-Item -path "C:\_CEGAT_PRO\_Perso" -name $matricule -type directory;
    
    
    #De 10000 a 19999
    if([int]$matricule -ge 10000 -and [int]$matricule -le 19999)
    {
        createUser -mat $matricule `
                   -pat "OU=3D,OU=Developpement," `
                   -n $nom `
                   -pre $prenom `
                   -adr $adresse `
                   -vil $ville `
                   -pos $postal `
                   -ftel1 $tel1 `
                   -ftel2 $tel2 `
                   -ftel3 $tel3;
           
         #Ajoute de l'utilisateur a son groupe    
         Add-ADGroupMember "Developpeurs 3D" $matricule;   
    }
    
    #De 20000 a 29999
    elseif([int]$matricule -ge 20000 -and [int]$matricule -le 29999)
    {
        createUser -mat $matricule `
                   -pat "OU=NET,OU=Developpement," `
                   -n $nom `
                   -pre $prenom `
                   -adr $adresse `
                   -vil $ville `
                   -pos $postal `
                   -ftel1 $tel1 `
                   -ftel2 $tel2 `
                   -ftel3 $tel3;
           
         #Ajoute de l'utilisateur a son groupe    
         Add-ADGroupMember "Developpeurs .NET" $matricule; 
    }

    #De 30000 a 39999
    elseif([int]$matricule -ge 30000 -and [int]$matricule -le 39999)
    {
        createUser -mat $matricule `
                   -pat "OU=Integration," `
                   -n $nom `
                   -pre $prenom `
                   -adr $adresse `
                   -vil $ville `
                   -pos $postal `
                   -ftel1 $tel1 `
                   -ftel2 $tel2 `
                   -ftel3 $tel3;
           
         #Ajoute de l'utilisateur a son groupe    
         Add-ADGroupMember "Integrateurs" $matricule; 
    }
    
    #De 40000 a 49999
    elseif([int]$matricule -ge 40000 -and [int]$matricule -le 49999)
    {
        createUser -mat $matricule `
                   -pat "OU=Design," `
                   -n $nom `
                   -pre $prenom `
                   -adr $adresse `
                   -vil $ville `
                   -pos $postal `
                   -ftel1 $tel1 `
                   -ftel2 $tel2 `
                   -ftel3 $tel3;
           
         #Ajoute de l'utilisateur a son groupe    
         Add-ADGroupMember "Designers" $matricule; 
    }
    
    #De 50000 a 59999
    elseif([int]$matricule -ge 50000 -and [int]$matricule -le 59999)
    {
        createUser -mat $matricule `
                   -pat "OU=Outils,OU=Test," `
                   -n $nom `
                   -pre $prenom `
                   -adr $adresse `
                   -vil $ville `
                   -pos $postal `
                   -ftel1 $tel1 `
                   -ftel2 $tel2 `
                   -ftel3 $tel3;
           
         #Ajoute de l'utilisateur a son groupe    
         Add-ADGroupMember "Testeurs Outils" $matricule; 
    }
    
    #De 60000 a 69999
    elseif([int]$matricule -ge 60000 -and [int]$matricule -le 69999)
    {
        createUser -mat $matricule `
                   -pat "OU=Jeux,OU=Test," `
                   -n $nom `
                   -pre $prenom `
                   -adr $adresse `
                   -vil $ville `
                   -pos $postal `
                   -ftel1 $tel1 `
                   -ftel2 $tel2 `
                   -ftel3 $tel3;
   
         #Ajoute de l'utilisateur a son groupe    
         Add-ADGroupMember "Testeurs Jeux" $matricule; 
    }
    
    #Pour les Gestionnaires
    if([int]$matricule -eq 10000 -or [int]$matricule -eq 20000 -or [int]$matricule -eq 30000 -or [int]$matricule -eq 40000 -or [int]$matricule -eq 50000 -or [int]$matricule -eq 60000)
    {
        Add-ADGroupMember Gestionnaires $matricule
    }
    
    #Droits NTFS sur le profil
    icacls "C:\_Profiles\"$matricule /inheritance:r;
    icacls "C:\_Profiles\"$matricule /grant "Administrateurs:(CI)(OI)(F)";
    icacls "C:\_Profiles\"$matricule /grant "Système:(CI)(OI)(F)";
    icacls "C:\_Profiles\"$matricule /grant "Gestionnaires:(CI)(OI)RX";
    icacls "C:\_Profiles\"$matricule /grant "${matricule}:(CI)(OI)M";
    
    #Droits NTFS sur le dossier Perso
    icacls "C:\_Perso\"$matricule /inheritance:r;
    icacls "C:\_Perso\"$matricule /grant "Administrateurs:(CI)(OI)(F)";
    icacls "C:\_Perso\"$matricule /grant "Système:(CI)(OI)(F)";
    icacls "C:\_Perso\"$matricule /grant "Gestionnaires:(CI)(OI)RX";
    icacls "C:\_Perso\"$matricule /grant "${matricule}:(CI)(OI)M";
 
}

function createUser($mat, $pat, $n, $pre, $adr, $vil, $pos, $ftel1, $ftel2, $ftel3)
{
    #Creation de l'utilisateur
    New-ADUser -Name $mat `
               -Path $pat + $parent `
               -Surname $n `
               -GivenName $prenom `
               -DisplayName $pre + " " + $n `
               -StreetAddress $adr `
               -City $vil `
               -PostalCode $pos `
               -OfficePhone $ftel1 `
               -OtherAttributes @{'otherTelephone'="$ftel2;$ftel3"} `
               -UserPrincipalName "$mat@DOTA.PRO" `
               -ProfilePath "C:\_CEGAT_PRO\_Profiles\"$mat `
               -HomeDrive "C:" `
               -HomeDirectory "\\AXE\_CEGAT_PRO\_Perso\"$mat `
               -Enabled $true `
               -PasswordNeverExpires $true `
               -AccountPassword (ConvertTo-SecureString $password -AsPlainText -force);
}


