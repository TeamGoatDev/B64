######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Installation de HyperV + Config des
# machines virtuelles et des cartes réseaux
#
# COURS: B61
# Serveur d'éxécution: SERVEUR RÉEL
# Serveurs modifiés: SERVEUR RÉEL
######################################################

Set-ExecutionPolicy Unrestricted

#Paramètres HyperV
$dossierVHDX = "C:\_VirDisque"
$dossierOrdi = "C:\_VirOrdi"

$nomServeur1 = "Ganondorf"
$nomServeur2 = "Gerudo"
$nomRouteur = "ZeroShell"

$nomCarte = "WAN"
$commInterne = "Comm_Int"
$commExterne = "Comm_Ext"
$nomCarteInterne = "CEGAT"
$nomCarteExterne = "Wan_config"





#Installation de HYPER-V
if((Get-WindowsFeature -Name Hyper-V).Installed -eq $false){

        # Installation de Hyper-V
        Write-Host "Hyper V n'est pas installé" -ForegroundColor Yellow
        Write-Host "Installation de Hyper-V en cours..."

        Install-WindowsFeature –Name Hyper-V -IncludeManagementTools -Restart;


        Write-Host "Installation de Hyper-V Terminé" -ForegroundColor Green
        Write-Host " Redémarrage en cours...." -ForegroundColor Yellow

}else{
        Rename-NetAdapter "Ethernet 4" $nomCarte

        Write-Host "Hyper V est installé " -ForegroundColor Green

        #Installation du RSAT au cas où il ne serait pas installé
        Add-WindowsFeature RSAT-Hyper-V-Tools –IncludeAllSubFeature
        Write-Host "Configuration de base en cours... " -ForegroundColor Yellow


        # Paramétrage dossier de service
        Set-VMHost -VirtualHardDiskPath $dossierVHDX -VirtualMachinePath $dossierOrdi

        # Paramétrage Commutateurs
        New-VMSwitch -ComputerName "." -Name $commInterne -SwitchType Internal
        New-VMSwitch -ComputerName "." -Name $commExterne -NetAdapterName $nomCarte
        Rename-NetAdapter -Name "vEthernet ($commInterne)" -NewName $nomCarteInterne
        Rename-NetAdapter -Name "vEthernet ($commExterne)"-NewName $nomCarteExterne



        # Création des machines virtuelles
        Write-Host "Création des machines virtuelles" -ForegroundColor Yellow

        #serveur1 + NumLock + Connexion Commutateur
        New-VM -Name $nomServeur1 -VHDPath "$dossierVHDX\S1_PROJET.VHDX" -Path $dossierOrdi `
		-MemoryStartupBytes 4096MB
        Set-VMBios -VMName $nomServeur1 -EnableNumLock;
        Add-VMNetworkAdapter -VMName $nomServeur1 -SwitchName $commInterne -IsLegacy $true


        #serveur2 + NumLock + Connexion Commutateur
        New-VM -Name $nomServeur2 -VHDPath "$dossierVHDX\S2_PROJET.VHDX" -Path $dossierOrdi  `
		-MemoryStartupBytes 4096MB
        Set-VMBios -VMName $nomServeur2 -EnableNumLock;
        Add-VMNetworkAdapter -VMName $nomServeur2 -SwitchName $commInterne -IsLegacy $true


        #ZeroShell + Connexion Commutateur
        New-VM -Name $nomRouteur -VHDPath "$dossierVHDX\Routeur_Projet.VHD" -Path $dossierOrdi `
		-MemoryStartupBytes 512MB 
        Add-VMNetworkAdapter -VMName $nomRouteur -SwitchName $commInterne -IsLegacy $true
        Add-VMNetworkAdapter -VMName $nomRouteur -SwitchName $commExterne -IsLegacy $true


        Write-Host "Installation terminée!" -ForegroundColor Green


        Write-Host "Paramétrage de la Carte CEGAT" -ForegroundColor Yellow
        $netadapter = Get-NetAdapter -Name “CEGAT”
        $netadapter | New-NetIPAddress -IPAddress 192.168.0.10 -PrefixLength 24

        Write-Host "SCRIPT TERMINÉ AVEC SUCCÈS" -ForegroundColor Green

}















