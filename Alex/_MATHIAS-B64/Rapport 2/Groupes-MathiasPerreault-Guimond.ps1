﻿#Mathias Perreault-Guimond
#11 mai 2015
#Création des Utilisateurs
#Exécuté à partir du Serveur 2
#Le serveur 2 sera modifier

#fichier CSV
$fCsv = "C:\PROG.csv"

$ouRacine = "OU=PROGRAMMATION,"
$domName = $ouRacine+(Get-ADDomain).DistinguishedName

$csv = Import-Csv -path $fCsv -delimiter ";" -encoding default

#Création des groupes
New-ADGroup -Name "grDeveloppeur3D" `
$developpeur3d = "grDeveloppeur3D"
$developpeurNet = "grDeveloppeurNet"
$integrateur = "grIntegrateur"
$designer = "grDesigners"
$testeurOutils = "grTesteursOutils"
$testeurJeux = "grTesteursJeux"
foreach($line in $csv) {

    $matricule = $line.Matricule

    if($matricule -ge 10000 -and $matricule -le 19999){
        $groupe = $developpeur3d
    }
    elseif($matricule -ge 20000 -and $matricule -le 29999){
        $groupe = $developpeurNet
    }
    elseif($matricule -ge 30000 -and $matricule -le 39999){
        $groupe = $integrateur
    }
    elseif($matricule -ge 40000 -and $matricule -le 49999){
        $groupe = $designer
    }
    elseif($matricule -ge 50000 -and $matricule -le 59999){
        $groupe = $testeurOutils
    }
    elseif($matricule -ge 60000 -and $matricule -le 69999){
        $groupe = $testeurJeux
    }

    if($matricule % 10000 -eq 0){ #modulo 10 000
        Add-ADGroupMember -Identity $gestionnaire -Members $matricule
    }

    Add-ADGroupMember -Identity $groupe -Members $matricule

}