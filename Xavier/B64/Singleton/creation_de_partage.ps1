#Xavier Hudon-Dansereau
#28/05/2015
#Lancer à partir du serveur InterneUn
#Ce code modifie les configurations du serveur InterneUn et InterneDeux
#------------------------------------------------------
#Déclaration
#------------
$v1Name = "InterneUn";
$v2Name = "InterneDeux";

#------------#
#Script      #
#------------#

creePartage $v1Name "_ANALYSE" "ANALYSE";
creePartage $v1Name "_INTEGRATION" "INTEGRATION";
creePartage $v2Name "_PROGRAMMATION" "PROGRAMMATION";
creePartage $v2Name "_TEST" "TEST";

function creePartage($serveur, $nom, $sPath){
    Write-Host "Suppression des vieux share et dossiers, puis création du partage ->$nom<- sur $serveur" -ForegroundColor Green
    #------------#
    #Déclaration #
    #------------#
    $cim = New-CimSession -ComputerName $serveur;
    $path = "\\"+$serveur+"\C$\"+$sPath

    #------------#
    #Nettoyage   #
    #------------#
    if(Get-SMBShare -Name $nom -ErrorAction 0 ){
        Remove-SmbShare -Name $nom -CimSession $cim;
    }
    if(Get-Item -Path "$path" -ErrorAction 0){
        Remove-Item -Path $path
    }

    #------------#
    #Création    #
    #------------#
    New-Item -Path $path -ItemType directory -Force
    
    #------------#
    #Droit       #
    #------------#
    icacls $path /inheritance:r
    icacls $path /grant "Gestionnaires:(OI)(CI)(F)"
    icacls $path /grant "Administrateurs:(CI)(OI)(F)"
    icacls $path /grant "Système:(CI)(OI)(F)"

    if($sPath -eq "ANALYSE"){
        icacls $path /grant "Integrateurs:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Designeurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)"  
    }
    elseif($sPath -eq "INTEGRATION"){
        icacls $path /grant "Desingneurs:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Integrateurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)"      
    }
    elseif($sPath -eq "PROGRAMMATION"){
        icacls $path /grant "Developpeur .NET:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Designeurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)" 
    }
    elseif($sPath -eq "TEST"){
        icacls $path /grant "Developpeur .NET:(OI)(CI)(M)"
        icacls $path /grant "Developpeurs 3D:(OI)(CI)(RX)"
        icacls $path /grant "Integrateurs:(OI)(CI)(RX)"
        icacls $path /grant "Testeurs Outils:(OI)(CI)(RX)" 
        icacls $path /grant "Testeurs Jeux:(OI)(CI)(RX)" 
    }

    #------------#
    #Share       #
    #------------#
    New-SmbShare -Name $nom  `
        -Path C:\$sPath `
        -FolderEnumerationMode AccessBased `
        -CimSession $cim `
        -CachingMode None `
}