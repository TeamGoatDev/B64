#####################################################
#Xavier Hduon-Dansereau
#05/05/2015
#Script #1
#Lancer à partir du serveur Réel
#Ce code modifie les configuration du serveur Réel
#####################################################
try{

    "Retrait de l'ancienne adresse IP"
    #Remove-NetIPAddress -IPAddress (Get-NetIPAddress -InterfaceAlias $adapter.Name).IPv4Address

    "Ajout d'une nouvelle adresse IP"
    new-NetIPAddress -InterfaceAlias $newName -IPAddress 10.57.64.25 -PrefixLength 16 -AddressFamily IPV4 -DefaultGateway 10.57.1.1

    "Ajout des parametres de DNS"
    Set-DnsClientServerAddress -InterfaceAlias $newName -ServerAddresses ("10.57.4.28","10.57.4.29")

    "Ajout de la carte virtuel externe"
    New-VMSwitch -Name "WAN" -NetAdapterName $newName

    "Ajout de la carte virtuel interne"
    New-VMSwitch -SwitchType Internal -Name "Interne"

    "Ajout des machines virtuels"
    New-VM -Name "InterneUn" -MemoryStartupBytes 4096mb -VHDPath c:\_VirDisque\S1_PROJET.vhdx -Path c:/VirOrdi
    New-VM -Name "InterneDeux" -MemoryStartupBytes 4096mb -VHDPath c:\_VirDisque\S2_PROJET.vhdx -Path c:/VirOrdi
    New-VM -Name "Routeur" -MemoryStartupBytes 512mb -VHDPath c:\_VirDisque\Routeur_Projet.vhd -Path c:/VirOrdi

    "Ajout de l'Adaptateur"
    Add-VMNetworkAdapter -VMName "InterneUn" -Name "AdapterInterne" -IsLegacy $true
    Connect-VMNetworkAdapter -VMName "InterneUn" -Name "AdapteurInterne" -SwitchName "VMInterne"
    
    "Ajout des num lock au startup"
    Set-VMBios -VMName "InterneUn" -EnableNumLock
    Set-VMBios -VMName "InterneDeux" -EnableNumLock

}catch{
    echo $_.Exception.GetType().FullName
    echo $_.Exception.Message
}
