#Nom : Arnaud Girardin
#Date : 2015-05-11
#Description : Dossiers et Partage
#Source : Serveur 1 (AXE)
#Modifications : Serveur 1 (AXE)et Serveur2 (LUNA)

#Fonction qui permet de creer un nouveau partage sur le serveur desire 
#(cheminPartage doit etre ANALYSE, INTEGRATION, PROGRAMMATION ou TEST pour que les droits fonctionnent)
function nouveauPartage($serveur, $nomPartage, $cheminPartage)
{
    $cim = New-CimSession -ComputerName $serveur;

     
    # On essaie de le supprimer s'il est déjà existant
    try
    {
        Remove-SmbShare -Name $nomPartage -CimSession $cim;
    }
    catch
    {
        Write-Host "Le partage que vous tentez de supprimer n'existe pas"
    }

    # On essaie de supprimer le dossier si il existe deja
    try
    {
        Remove-Item -Path \\$serveur\C$\$cheminPartage
    }
    catch
    {
        Write-Host "Le dossier que vous tentez de supprimer n'existe pas"
    }
    
    #Creation du dossier
    New-Item -Path \\$serveur\C$\$cheminPartage  -ItemType directory -Force

    #NTFS
    $path = "\\"+$serveur+"\C$\"+$cheminPartage

    #Droits que tous les dossiers ont de base
    icacls $path /inheritance:r
    icacls $path /grant "Gestionnaires:(OI)(CI)(F)"
    icacls $path /grant "Administrateurs:(CI)(OI)(F)"
    icacls $path /grant "Système:(CI)(OI)(F)"
    
    #Droits conditionnels--------------------------------------------------------------------------------------------------------
    
    #Droits sur le dossier ANALYSE
    if($cheminPartage -eq "ANALYSE")
    {
        icacls $path /grant "Integrateurs:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Designeurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)"  
    }
    elseif($cheminPartage -eq "INTEGRATION")
    {
        icacls $path /grant "Designeurs:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Integrateurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)"      
    }
    elseif($cheminPartage -eq "PROGRAMMATION")
    {
        icacls $path /grant "Developpeurs .NET:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Designeurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)" 
    }
    elseif($cheminPartage -eq "TEST")
    {
        icacls $path /grant "Developpeurs .NET:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Integrateurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)" 
    }
    
    #----------------------------------------------------------------------------------------------------------------------------

    #Creation du partage sur le serveur desire
    New-SmbShare -Name $nomPartage `
                 -Path C:\$cheminPartage `
                 -CimSession $cim `
                 -FolderEnumerationMode AccessBased `
                 -CachingMode None
  
    Write-Host "Creation du partage $nomPartage sur $serveur RÉUSSIE " -ForegroundColor Yellow

}

$serveur1 = "AXE";
$serveur2 = "LUNA";

nouveauPartage -serveur $serveur1 -nomPartage _ANALYSE -cheminPartage ANALYSE;
nouveauPartage -serveur $serveur1 -nomPartage _INTEGRATION -cheminPartage INTEGRATION;
nouveauPartage -serveur $serveur1 -nomPartage _PROGRAMMATION -cheminPartage PROGRAMMATION;
nouveauPartage -serveur $serveur2 -nomPartage _TEST -cheminPartage TEST;

