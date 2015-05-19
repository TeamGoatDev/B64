#USERS
$csvFileMembres = " "
$motDePasse = "AAAaaa111"
$lecteurPersonnel = "P:"




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


    $cheminProfil = ""

    $dossierPersonnel = "$lecteurPersonnel/$matricule";



    Write-Host "Ajout de $prenom $nom $matricule ..."



    Write-Host "Création de son dossier personnel"
    New-Item -Path $dossierPersonnel -ItemType Directory




    New-ADUser -Name $prenom `
    -DisplayName $nomComplet `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -GivenName $prenom `

    -HomePhone $telDom `
    -OfficePhone $telBur1 `
    -OtherAttributes @{
    "mobile"=$telMobile
    } `
    -Surname $nom `
    -UserPrincipalName $nomOuvSession `
    -AccountPassword (ConvertTo-SecureString $motDePasse -AsPlainText -force)













  
}