######################################################
# Nom: Jean-William Perreault
# Date: 7 mai 2015
#
# Objectif: Installation de HyperV + Config des
# machines virtuelles
#
# Serveur d'�x�cution: SERVEUR R�EL
# Serveurs modifi�s: SERVEUR R�EL
######################################################

Set-ExecutionPolicy Unrestricted

#Param�tres HyperV
$dossierVHDX = "C:\_VirDisque"
$dossierOrdi = "C:\_VirOrdi"

$nomServeur1 = "SERVEUR_1"
$nomServeur2 = "SERVEUR_2"
$nomRouteur = "ZeroShell"


#Installation de HYPER-V
if((Get-WindowsFeature -Name Hyper-V).Installed -eq $false){

        # Installation de Hyper-V
        Write-Host "Hyper V n'est pas install�" -ForegroundColor Yellow
        Write-Host "Installation de Hyper-V en cours..."

        Install-WindowsFeature �Name Hyper-V -IncludeManagementTools -Restart;


        Write-Host "Installation de Hyper-V Termin�" -ForegroundColor Green
        Write-Host " Red�marrage en cours...." -ForegroundColor Yellow

}else{
        Write-Host "Hyper V est install� " -ForegroundColor Green

        #Installation du RSAT au cas o� il ne serait pas install�
        Add-WindowsFeature RSAT-Hyper-V-Tools �IncludeAllSubFeature
        Write-Host "Configuration de base en cours... "



        # Param�trage dossier de service
        Set-VMHost -VirtualHardDiskPath $dossierVHDX -VirtualMachinePath $dossierOrdi

        # Param�trage Commutateurs
        New-VMSwitch -ComputerName "." -Name "Comm_Interne" -SwitchType Internal
        New-VMSwitch -ComputerName "." -Name "Comm_Externe"  -SwitchType External -NetAdapterName "WAN"


        # Cr�ation des machines virtuelles
        Write-Host "Cr�ation des machines virtuelles"

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















