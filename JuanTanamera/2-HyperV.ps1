######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Installation de HyperV + Config des
# machines virtuelles
#
# Serveur d'éxécution: SERVEUR RÉEL
# Serveurs modifiés: SERVEUR RÉEL
######################################################

Set-ExecutionPolicy Unrestricted

#Paramètres HyperV
$dossierVHDX = "C:\_VirDisque"
$dossierOrdi = "C:\_VirOrdi"

$nomServeur1 = "SERVEUR_1"
$nomServeur2 = "SERVEUR_2"
$nomRouteur = "ZeroShell"


#Installation de HYPER-V
if((Get-WindowsFeature -Name Hyper-V).Installed -eq $false){

        # Installation de Hyper-V
        Write-Host "Hyper V n'est pas installé" -ForegroundColor Yellow
        Write-Host "Installation de Hyper-V en cours..."

        Install-WindowsFeature –Name Hyper-V -IncludeManagementTools -Restart;


        Write-Host "Installation de Hyper-V Terminé" -ForegroundColor Green
        Write-Host " Redémarrage en cours...." -ForegroundColor Yellow

}else{
        Write-Host "Hyper V est installé " -ForegroundColor Green

        #Installation du RSAT au cas où il ne serait pas installé
        Add-WindowsFeature RSAT-Hyper-V-Tools –IncludeAllSubFeature
        Write-Host "Configuration de base en cours... "



        # Paramétrage dossier de service
        Set-VMHost -VirtualHardDiskPath $dossierVHDX -VirtualMachinePath $dossierOrdi

        # Paramétrage Commutateurs
        New-VMSwitch -ComputerName "." -Name "Comm_Interne" -SwitchType Internal
        New-VMSwitch -ComputerName "." -Name "Comm_Externe"  -SwitchType External -NetAdapterName "WAN"


        # Création des machines virtuelles
        Write-Host "Création des machines virtuelles"

        #serveur1 + NumLock + Connexion Commutateur
        New-VM -Name $nomServeur1 -VHDPath "$dossierVHDX\S1_PROJET.VHDX" -Path $dossierOrdi  -MemoryStartupBytes 4096MB
        Set-VMBios -VMName $nomServeur1 -EnableNumLock;
        Add-VMNetworkAdapter -VMName $nomServeur1 -SwitchName "Comm_Interne" -IsLegacy $true


        #serveur2 + NumLock + Connexion Commutateur
        New-VM -Name $nomServeur2 -VHDPath "$dossierVHDX\S2_PROJET.VHDX" -Path $dossierOrdi  -MemoryStartupBytes 4096MB
        Set-VMBios -VMName $nomServeur2 -EnableNumLock;
        Add-VMNetworkAdapter -VMName $nomServeur2 -SwitchName "Comm_Interne" -IsLegacy $true


        #ZeroShell + Connexion Commutateur
        New-VM -Name $nomRouteur -VHDPath "$dossierVHDX\ROUTEUR_PROJET.VHDX" -Path $dossierOrdi -MemoryStartupBytes 512MB 
        Add-VMNetworkAdapter -VMName $nomRouteur -SwitchName "Comm_Interne" -IsLegacy $true

      


}















