$fCsv = "c:\Prog.csv"


$csvUsagers = Import-Csv -path $fCsv -delimiter ";" -encoding default

$TLD = ".PRO"
$ADServer_name = "Tails"
$ADServer = ($ADServer_name + $TLD)
$ADMember_name = "Ruby"
$ADMember = ($ADMember_name + $TLD)
$homeDrive = "P:\"

# Création des utilisateurs
# CSV = Matricule;Nom;Prenom;Adresse;Ville;CodePostal;Tel1;Tel2;Tel3

$path1= "OU=PROGRAMMATION,DC=NEXTLEVEL,DC=pro"

foreach($Usager in $csvUsagers)
{   


    $usagerNom = $Usager.Nom
    New-ADUser -AccountPassword (ConvertTo-SecureString "AAAaaa111" -AsPlainText -force) `
	-ChangePasswordAtLogon $false `
	-Name $Usager.Matricule `
	-GivenName $Usager.Prenom `
	-Surname $Usager.Nom `
	-StreetAddress $Usager.Adresse `
	-City $Usager.Ville `
	-PostalCode $Usager.CodePostal `
	-Description "Usager du département Programmation" `
	-HomePhone $Usager.Tel1 `
	-HomeDrive $homeDrive `
	-HomeDirectory "\\$ADServer_name\Users$\$UsagerNom.V4" `
	-PasswordNeverExpires: $true `
	-Enabled: $true `
	-path $path1
	
	
}

# Mettre les utilisateurs dans les bons groupes et OU


$fCsv = "c:\Prog.csv"


$csvUsagers = Import-Csv -path $fCsv -delimiter ";" -encoding default

$TLD = "PRO"
$ADServer_name = "Tails"
$ADServer = ($ADServer_name + $TLD)
$ADMember_name = "Ruby"
$ADMember = ($ADMember_name + $TLD)
$homeDrive = "P:\"







foreach ($usager in $csvUsagers)
{
     $matricule = $usager.Matricule
     $userCurrent = Get-ADUser -Filter "name -like $matricule"

	 if($matricule -ge 10000 -and $matricule -lt 20000)
      {
        Add-ADGroupMember -Identity  Developpeurs_3D -member $userCurrent
      }
    

    		
    if($matricule -ge 20000 -and $matricule -lt 30000)
        {
		Add-ADGroupMember -Identity  Developpeurs_NET -member $userCurrent
		#Move-ADObject -Identity $usager.Matricule -TargetPath 'OU=Developpeurs_NET,DC=NEXTLEVEL,DC=pro'
		}



	if($matricule -ge 30000 -and $matricule -lt 40000)
		{
        Add-ADGroupMember -Identity  Integrateur -member $userCurrent
		#Move-ADObject -Identity $usager.Matricule -TargetPath 'OU=Integrateur,DC=NEXTLEVEL,Dc=pro'
	    }

	if($matricule -ge 40000 -and $matricule -lt 50000)
	    {
    	Add-ADGroupMember -Identity  DesignerWeb -member $userCurrent
		#Move-ADObject -Identity $usager.Matricule -TargetPath 'OU=DesignerWeb,DC=NEXTLEVEL,Dc=pro'
		}
	if($matricule -ge 50000 -and $matricule -lt 60000)
		{
        Add-ADGroupMember -Identity  Testeur_outils -member $userCurrent
		#Move-ADObject -Identity $usager.Matricule -TargetPath 'OU=TESTEURS_OUTILS,DC=NEXTLEVEL,Dc=pro'	
	    }
    if($matricule -ge 60000 -and $matricule -lt 70000)
		{
        Add-ADGroupMember -Identity  Testeur_jeux -member $userCurrent
		#Move-ADObject -Identity $usager.Matricule -TargetPath 'OU=TESTEURS_JEUX,DC=NEXTLEVEL,Dc=pro'	
	    }

	if($matricule -eq 10000)
        {
		Add-ADGroupMember -Identity  gestionnaire -member $userCurrent
		}
	if($matricule -eq 20000)
		{
        Add-ADGroupMember -Identity gestionnaire -member $userCurrent
		}
	if($matricule -eq 30000)
		{
        Add-ADGroupMember -Identity  gestionnaire -member $userCurrent
		}
	if($matricule -eq 40000)
		{
        Add-ADGroupMember -Identity  gestionnaire -member $userCurrent
		}
	if($matricule -eq 50000)
		{
        Add-ADGroupMember -Identity  gestionnaire -member $userCurrent
		}
	if($matricule -eq 60000)
		{
        Add-ADGroupMember -Identity  gestionnaire -member $userCurrent
	    }

}