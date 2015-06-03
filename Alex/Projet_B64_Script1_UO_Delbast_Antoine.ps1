#script 1 - Création des unités d'organisation
#Auteur  : Antoine Delbast
#Exécuté sur controleur de domaine (serveur1)
#Modifie contrôleur de domaine (serveur1)


 New-ADOrganizationalUnit -Description:"PROGRAMMATION" `
  -Name:"PROGRAMMATION" -Path:"DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
   New-ADOrganizationalUnit -Description:"ORDINATEURS" `
  -Name:"ORDINATEURS" -Path:"OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
       New-ADOrganizationalUnit -Description:"DEVELOPPEURS" `
  -Name:"DEVELOPPEURS" -Path:"OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
      New-ADOrganizationalUnit -Description:"DEVELOPPEURS_3D" `
  -Name:"DEVELOPPEURS_3D" -Path:"OU=DEVELOPPEURS,OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
      New-ADOrganizationalUnit -Description:"DEVELOPPEURS_NET" `
  -Name:"DEVELOPPEURS_NET" -Path:"OU=DEVELOPPEURS,OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 

  
     New-ADOrganizationalUnit -Description:"INTEGRATEURS" `
  -Name:"INTEGRATEURS" -Path:"OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
     New-ADOrganizationalUnit -Description:"DESIGNERS" `
  -Name:"DESIGNERS" -Path:"OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
     New-ADOrganizationalUnit -Description:"TESTEURS" `
  -Name:"TESTEURS" -Path:"OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
      New-ADOrganizationalUnit -Description:"TESTEURS_OUTILS" `
  -Name:"TESTEURS_OUTILS" -Path:"OU=TESTEURS,OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 
  
      New-ADOrganizationalUnit -Description:"TESTEURS_JEUX" `
  -Name:"TESTEURS_JEUX" -Path:"OU=TESTEURS,OU=PROGRAMMATION,DC=NEXTLEVEL,DC=PRO" `
  -ProtectedFromAccidentalDeletion:$false 