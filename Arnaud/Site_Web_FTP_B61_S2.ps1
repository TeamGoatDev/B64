#Nom : Arnaud Girardin
#Date : 2015-05-21
#Description : Creation des Sites Web
#Source : Serveur 2 (LUNA)
#Modifications : Serveur 2 (LUNA)

#Creation des Dossiers
New-Item -path C:\ -name "_CEGAT_PRO" -type directory -Force;
New-Item -path C:\_CEGAT_PRO -name "WEBD" -type directory -Force;
New-Item -path C:\_CEGAT_PRO -name "WEBS" -type directory -Force;
New-Item -path C:\_CEGAT_PRO -name "FTPD" -type directory -Force;
New-Item -path C:\_CEGAT_PRO -name "FTPA" -type directory -Force;

#Creation du site  Departemental et ajout dans le DNS
New-Website -Name "PRO" -Port 80 -IPAddress "192.168.61.102" -PhysicalPath C:\_CEGAT_PRO\WEBD -Ssl;
Add-DnsServerResourceRecordA -Name PRO -ComputerName "AXE.PRO" -IPv4Address "192.168.61.102";

#Creation du site Securise et ajout dans le DNS
New-Website -Name "SECPRO" -Port 443 -IPAddress "192.168.61.102" -PhysicalPath C:\_CEGAT_PRO\WEBS -Ssl;
Add-DnsServerResourceRecordA -Name SECPRO -ComputerName "AXE.PRO" -IPv4Address "192.168.61.102";
