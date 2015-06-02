#Nom : Arnaud Girardin
#Date : 2015-05-07
#Description : Parametrage de Hyper-V
#Source : Serveur Reel
#Modifications : Serveur Reel

#On va chercher la carte
if($name = Get-NetAdapter -Name "Ethernet 4")
{
    $name = $name.Name;

    Rename des cartes reseau
    Rename-NetAdapter -Name $name -NewName "OnBoard";

    $diskPath = "C:\_VirDisque";
    $machinePath = "C:\_VirOrdi";

    #Changement des paths
    Set-VMHost -VirtualHardDiskPath $diskPath -VirtualMachinePath $machinePath;

    #Creation des commutateurs
    New-VMSwitch -Name Comm_INTERNE -SwitchType Internal
    New-VMSwitch -Name Comm_EXTERNE -NetAdapterName OnBoard

    #Modification Adresse IP Interne
    $name = Get-NetAdapter -Name "vEthernet (Comm_INTERNE)";
    $name = $name.Name;

    #Changement de l'adresse de la carte
    New-NetIPAddress -InterfaceAlias $name -PrefixLength 24 -IPAddress 192.168.0.100; 

    #Creation des ordinateurs virtuels

    $vmName = "SERVEUR_1"

    #Serveur 1
    New-VM -Name $vmName -Generation 1 -MemoryStartupBytes 4096MB -VHDPath $diskPath"\S1_PROJET.vhdx" 

    #On enleve la carte de base
    Remove-VMNetworkAdapter -VMName $vmName;

    #On ajoute le commutateur
    Add-VMNetworkAdapter -VMName $vmName -SwitchName Comm_INTERNE -IsLegacy $true

    #Caps lock
    Set-VMBios -VMName $vmName -EnableNumLock 

    $vmName = "SERVEUR_2"

    #Serveur 2
    New-VM -Name $vmName -Generation 1 -MemoryStartupBytes 4096MB -VHDPath $diskPath"\S2_PROJET.vhdx" 

    #On enleve la carte de base
    Remove-VMNetworkAdapter -VMName $vmName;

    #On ajoute le commutateur
    Add-VMNetworkAdapter -VMName $vmName -SwitchName Comm_INTERNE -IsLegacy $true

    #Caps lock
    Set-VMBios -VMName $vmName -EnableNumLock 

	$vmName = "ROUTEUR"

    #Routeur
    New-VM -Name $vmName -Generation 1 -MemoryStartupBytes 512MB -VHDPath $diskPath"\ROUTEUR_PROJET.vhd" 

    #On enleve la carte de base
    Remove-VMNetworkAdapter -VMName $vmName;

    #On ajoute le commutateur
    Add-VMNetworkAdapter -VMName $vmName -SwitchName Comm_INTERNE -IsLegacy $true
	Add-VMNetworkAdapter -VMName $vmName -SwitchName Comm_EXTERNE -IsLegacy $true

    #Rename des cartes
    Rename-NetAdapter -Name "vEthernet (Comm_EXTERNE)" -NewName "WAN_CONFIG";
	Rename-NetAdapter -Name "vEthernet (Comm_INTERNE)" -NewName "CEGAT";
	

}
else
{
   Write-Host "Implossible de trouver la carte !"
}