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
New-Item -path C:\_CEGAT_PRO\FTPA -name "FTP1" -type directory -Force;
New-Item -path C:\_CEGAT_PRO\FTPA -name "FTP2" -type directory -Force;
New-Item -path C:\_CEGAT_PRO\FTPA -name "FTP3" -type directory -Force;

#Droits NTFS pour le FTPA
$path = "C:\_CEGAT_PRO\FTPA";

icacls $path /inheritance:r
icacls $path /grant "Administrateurs:(OI)(CI)(F)"
icacls $path /grant "Système:(OI)(CI)(F)"
icacls "$path\FTP1" /grant "FTP1:(OI)(CI)(M)"
icacls "$path\FTP2" /grant "FTP2:(OI)(CI)(M)"
icacls "$path\FTP3" /grant "FTP3:(OI)(CI)(M)"

#Creation du site  Departemental et ajout dans le DNS
New-Website -Name "PRO" -Port 80 -IPAddress "192.168.61.102" -PhysicalPath C:\_CEGAT_PRO\WEBD;
Add-DnsServerResourceRecordA -Name PRO -ComputerName "AXE.PRO" -ZoneName "AXE.PRO" -IPv4Address "192.168.61.102";

#Creation du site Securise et ajout dans le DNS
New-Website -Name "SECPRO" -Port 443 -IPAddress "192.168.61.102" -PhysicalPath C:\_CEGAT_PRO\WEBS -Ssl;
Remove-WebBinding -Name "SECPRO";
New-WebBinding -Name "SECPRO" -IP "192.168.61.102" -Port 443 -Protocol https
Add-DnsServerResourceRecordA -Name SECPRO -ComputerName "AXE.PRO" -ZoneName "AXE.PRO" -IPv4Address "192.168.61.102";

#Creation du site FTP departemental
New-WebFtpSite -Name FDPRO -IPAddress "192.168.61.102" -PhysicalPath C:\_CEGAT_PRO\FTPD -Port 21;
Add-DnsServerResourceRecordA -Name FDPRO -ComputerName "AXE.PRO" -ZoneName "AXE.PRO" -IPv4Address "192.168.61.102";

#Creation du site FTP departemental
New-WebFtpSite -Name FPRO -IPAddress "192.168.61.103" -PhysicalPath C:\_CEGAT_PRO\FTPD -Port 21;
Add-DnsServerResourceRecordA -Name FPRO -ComputerName "AXE.PRO" -ZoneName "AXE.PRO" -IPv4Address "192.168.61.103";