#Nom : Arnaud Girardin
#Date : 2015-05-11
#Description : Creation des Groupes
#Source : Serveur 1 (AXE)
#Modifications : Serveur 1 (AXE)

#Groupe pour les Developpeurs 3D
New-ADGroup -Name "Developpeurs 3D" `
            -SamAccountName "Developpeurs" `
            -GroupCategory Security `
            -GroupScope Global `
            -DisplayName "Developpeurs 3D" `
            -Path "OU=Programmation,DC=DOTA,DC=PRO" `
            -Description "Groupe des Developpeurs 3D";

#Groupe pour les Developpeurs NET
New-ADGroup -Name "Developpeurs .NET" `
            -SamAccountName "Developpeurs" `
             -GroupCategory Security `
             -GroupScope Global `
             -DisplayName "Developpeurs .NET" `
             -Path "OU=Programmation,DC=DOTA,DC=PRO" `
             -Description "Groupe des Developpeurs .NET";

#Groupe pour les Integrateurs
New-ADGroup -Name "Integrateurs" `
            -SamAccountName "Integrateurs" `
            -GroupCategory Security `
            -GroupScope Global `
            -DisplayName "Integrateurs" `
            -Path "OU=Programmation,DC=DOTA,DC=PRO" `
            -Description "Groupe des Integrateurs";

#Groupe pour les Designeurs
New-ADGroup -Name "Designeurs" `
            -SamAccountName "Designeurs" `
            -GroupCategory Security `
            -GroupScope Global `
            -DisplayName "Designeurs" `
            -Path "OU=Programmation,DC=DOTA,DC=PRO" `
            -Description "Groupe des Designeurs";

#Groupe pour les Testeurs d'Outils
New-ADGroup -Name "Testeurs Outils" `
            -SamAccountName "Testeurs Outils" `
            -GroupCategory Security `
            -GroupScope Global `
            -DisplayName "Testeurs Outils" `
            -Path "OU=Programmation,DC=DOTA,DC=PRO" `
            -Description "Groupe des Testeurs d'outils";

#Groupe pour les Testeurs de jeux
New-ADGroup -Name "Testeurs Jeux" `
            -SamAccountName "Testeurs Jeux" `
            -GroupCategory Security `
            -GroupScope Global `
            -DisplayName "Testeurs Jeux" `
            -Path "OU=Programmation,DC=DOTA,DC=PRO" `
            -Description "Groupe des Testeurs de jeux";

#Groupe pour les Gestionnaires
New-ADGroup -Name "Gestionnaires" `
            -SamAccountName "Gestionnaires" `
            -GroupCategory Security `
            -GroupScope Global `
            -DisplayName "Gestionnaires" `
            -Path "OU=Programmation,DC=DOTA,DC=PRO" `
            -Description "Groupe des Gestionnaires";