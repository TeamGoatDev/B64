#Etapes pour B64

###Setup Initial du Réel
- Changer Le nom du réel Serveur-reel
- Rouler seulement l'installation d'hyperV
- Rouler le reste du script
- Aller dans Gestionnaire Hyper-V
	-  Ouvrir parametres du serveur_1
		-  Dans carte reseau > Commutateur virtuel -> Comm_Int
	- Faire la même chose pour serveur_2
- Starter tous les ordis pour les laisser loader
- Ouvrir ncpa.cpl
	- Setup la Wan
		- Changer l'addresse IP
		- Changer la passerelle
		- Changer le DNS
	- Faire la meme chose pour CEGAT
- Activer mode de session étendu:
	- Aller dans Hyper-V > Action > Parametres hyper-v > Strategies <>
	- Cocher autoriser le mode de session étendu

###Connexion Serveur 1
- Aller sur serveur_1
	- Slider a élevée
	- Afficher les options
		- Cocher enregister <>
	- Ressources locales
		- Tout cocher
	- Ok!
	- Administrateur AAAaaa111
	- ncpa.cpl sur serveur_1
	- Renommer Ethernet 6 -> CEGAT
		- Propriété
		- Addresse IP
		- Passerelle
		- DNS = LUI-MEME
	- **Renomme le serveur si tu veux**

###Connexion Serveur 2
- Aller sur serveur_2
	- ncpa.cpl
	- Renommer Ethernet 6 -> CEGAT
		- Propriétés
		- Addresse IP
		- Passerelle
		- DNS
	- **Renomme le serveur si tu veux**
	
###Création du Domaine
- Retourner sur Serveur 1
	- Ajouter le role AD-DS et DNS
	- FLAG
		- Promouvoir en controleur de domaine
		- Ajouter une nouvelle foret
		- THEME.PRO
		- Installer
		- Entrer un mot de passe (AAAaaa111 master race)
		- NEXT
		- Ya une erreur, fait next
		- Fais next tout le temps
		- C'est fait!
	- WIndows+Pause
		- Modifier parametres
		- Modifier…
		- Membre d'un Domaine:
			- Entrer le domaine THEME.PRO
		- Connecter THEME\ADMINISTRATEUR
		- Si ca marque Bienvenue, t'es good, sinon, t'es fucked!
		
###Outils d'Administration
- Relogger le serveur_2 sur le domaine THEME\administrateur
	- Ajouter la FONCTIONNALITÉ (skipper les roles) "Gestion des Stratégies de groupes"
	- Ajouter aussi Outil d'administration de serveur distant
		- Outils d'administration de roles
			- Outils AD DS et AD LDS
			
###Création Structure AD
- Rouler le script 1 sur le serveur 2
- Ouvrir la console UOAD
	- Veriier que c'est la THEME.PRO > PROGRAMMATION > Tout est ici
- Mettre PROG.csv dans C:\_cours\ (t'es mieux de te padder en le copiant dans le C pour etre sur)
- Runner le script 2
- 