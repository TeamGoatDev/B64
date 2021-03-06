#Creation de la OU Programmation qui contiendra toutes les autres
New-ADOrganizationalUnit -Name Programmation 
						 -Path "DC=DOTA,DC=PRO";

#Creation de la OU Ordinateurs
New-ADOrganizationalUnit -Name Ordinateurs 
						 -Path "OU=Programmation,DC=DOTA,DC=PRO";

#Creation de la OU Integration
New-ADOrganizationalUnit -Name Integration -Path "OU=Programmation,DC=DOTA,DC=PRO";

#Creation de la OU Design
New-ADOrganizationalUnit -Name Design -Path "OU=Programmation,DC=DOTA,DC=PRO";

#Creation de la OU Developpement et de ses enfants
New-ADOrganizationalUnit -Name Developpement `
						 -Path "OU=Programmation,DC=DOTA,DC=PRO";
						 
New-ADOrganizationalUnit -Name "3D" `
						 -Path "OU=Programmation,OU=Developpement,DC=DOTA,DC=PRO";
						 
New-ADOrganizationalUnit -Name NET `
						 -Path "OU=Programmation,OU=Developpement,DC=DOTA,DC=PRO";

#Creation de la OU Test et de ses enfants
New-ADOrganizationalUnit -Name Test `
						 -Path "OU=Programmation,DC=DOTA,DC=PRO";
						 
New-ADOrganizationalUnit -Name Outils `
						 -Path "OU=Test,OU=Programmation,DC=DOTA,DC=PRO";

New-ADOrganizationalUnit -Name Jeux `
						 -Path "OU=Test,OU=Programmation,DC=DOTA,DC=PRO";
