###############################################
#Création des groupes                         #
#Auteur : Antoine Delbast                     #
#Date : 14 Avril                              #
#Serveur sur lequel c'est éxécuté : serveur 1 #
#Serveur modifié : Serveur 1 et 2		      #		
###############################################



New-ADGroup -GroupScope Global -Name Developpeurs_3D -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO" 

New-ADGroup -GroupScope Global -Name Developpeurs_NET -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO" 

New-ADGroup -GroupScope Global -Name Integrateur -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO" 

New-ADGroup -GroupScope Global -Name DesignerWeb -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO"

New-ADGroup -GroupScope Global -Name Testeur_jeux -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO" 

New-ADGroup -GroupScope Global -Name Testeur_outils -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO" 
	
New-ADGroup -GroupScope Global -Name Gestionnaire -GroupCategory Security -Path "OU=Programmation,DC=NEXTLEVEL,DC=PRO" 
	

