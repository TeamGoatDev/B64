#Xavier Hudon-Dansereau
#Lancer ce script sur InterneUn

# Création de groupes

$cheminDesGroupes = "OU=PROGRAMMATION,"+(Get-ADDomain).DistinguishedName

$lesGroupes = @(
    "Développeur .NET",
    "Dévelopeur 3D",
    "Intégrateurs",
    "Designers WEB",
    "Testeurs d'outils",
    "Testeurs de jeux",
    "Gestionnaires"
)
foreach($groupe in $lesGroupes){ 
    New-ADGroup `
    -GroupScope Global `
    -Name $groupe `
    -Description "Groupe des $groupe" `
    -GroupCategory Security `
    -Path $cheminDesGroupes
}