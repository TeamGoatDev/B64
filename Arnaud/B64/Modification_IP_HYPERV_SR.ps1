#Nom : Arnaud Girardin
#Date : 2015-05-04
#Description : Creation des dossiers pour le DFS
#Source : Serveur Reel
#Modifications : Serveur Reel

#Rename Ordinateur

#Obtention du nom de la carte reseau
$name = Get-NetAdapter -Name "Ethernet 4";
$name = $name.Name;

#Changement de l'adresse de la carte
New-NetIPAddress -InterfaceAlias $name -PrefixLength 16 -DefaultGateway 10.57.1.1 -IPAddress 10.57.64.23; 

#Assignation du DNS
Set-DnsClientServerAddress -InterfaceAlias $name -ServerAddresses 10.57.4.28, 10.57.4.29;

#Hyper-V
Install-WindowsFeature Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart
