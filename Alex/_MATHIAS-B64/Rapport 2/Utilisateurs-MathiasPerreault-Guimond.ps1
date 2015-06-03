#Mathias Perreault-Guimond
#11 mai 2015
#Création des Utilisateurs
#Exécuté à partir du Serveur 2
#Le serveur 2 sera modifier

#fichier CSV
$fCsv = "C:\_cours\PROG.csv"

#Variables
$ouRacine = "OU=PROGRAMMATION,"
$domName = $ouRacine+(Get-ADDomain).DistinguishedName
$password = "AAAaaa111"


#Unité d'organisation
$developpeur3d = "OU=3D,OU=Developpeurs,$domName"
$developpeurNet = "OU=NET,OU=Developpeurs,$domName"
$integrateur = "OU=Integrateurs,$domName"
$designer = "OU=DesignersWeb,$domName"
$testeurOutils = "OU=Outils,OU=Testeurs,$domName"
$testeurJeux = "OU=Jeux,OU=Testeurs,$domName"

$csv = Import-Csv -path $fCsv -delimiter ";" -encoding default

#Foreach dans le csv
foreach($line in $csv) {

$nom = $line.Nom
$prenom = $line.Prenom
$matricule = $line.Matricule
$tel = $line.Tel1
$tel2 = $line.Tel2
$tel3 = $line.Tel3
$adresse = $line.Adresse
$ville = $line.Ville
$codePostal = $line.CodePostal
$path = ""

if($matricule -ge 10000 -and $matricule -le 19999){
$path = $developpeur3d
}
elseif($matricule -ge 20000 -and $matricule -le 29999){
$path = $developpeurNet
}
elseif($matricule -ge 30000 -and $matricule -le 39999){
$path = $integrateur
}
elseif($matricule -ge 40000 -and $matricule -le 49999){
$path = $designer
}
elseif($matricule -ge 50000 -and $matricule -le 59999){
$path = $testeurOutils
}
elseif($matricule -ge 60000 -and $matricule -le 69999){
$path = $testeurJeux
}
#Création des utilisateurs
New-ADUser -Name $matricule `
  -Path $path `
  -DisplayName "$prenom $nom" `
  -GivenName $prenom `
  -Description "Utilisateur du département programmation" `
  -Surname $nom `
  -StreetAddress $adresse `
  -City $ville `
  -PostalCode $codePostal `
  -OtherAttributes @{'otherTelephone'="$tel2;$tel3";'telephoneNumber'="$tel"} `
  -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
  -PasswordNeverExpires $true `
  -Enabled $true
    }