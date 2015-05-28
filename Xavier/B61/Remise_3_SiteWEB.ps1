#Xavier Hudon-Dansereau
#Script à lancer sur le serveur InterneDeux
#Crée les sites web et ftp

$path1 = "C:\_CEGAT_PRO\WEBD"
$path2 = "C:\_CEGAT_PRO\WEBS"
$path3 = "C:\_CEGAT_PRO\FTPD"
$path4 = "C:\_CEGAT_PRO\FTPA"

Import-Module WebAdministration

New-Item -Path $path1 -ItemType directory -Force
New-Item $path1+"\"+index.htm -type file -Force
"WEBD / Interieur+Exterieur / Xavier / 192.168.0.20" | Out-File $path1+"\"+index.htm -Append
New-Website -Name "PRO" -Port 80 -IPAddress "192.168.0.20" -PhysicalPath $path1

New-Item -Path $path2 -ItemType directory -Force
New-Item $path2+"\"+index.htm -type file
"WEBS Secure / Interieur / Xavier / 192.168.0.20" | Out-File $path2+"\"+index.htm -Append
New-Website -Name "SECPRO" -Port 443 -IPAddress "192.168.0.20" -PhysicalPath $path2 -ssl

New-Item -Path $path3 -ItemType directory -Force
New-Item $path3+"\"+testFile.txt -type file
"FTPD / Interieur+Exterieur / Xavier / 192.168.0.20" | Out-File $path3+"\"+testFile.txt -Append
New-WebFtpSite -Name "FDPRO" -IPAddress "192.168.0.20" -Port "21" -PhysicalPath $path3

New-Item -Path $path4 -ItemType directory -Force
New-Item $path4+"\"+testFile.txt -type file
"FTPA / Interieur+Exterieur / Xavier / 192.168.0.20" | Out-File $path4+"\"+testFile.txt -Append
New-WebFtpSite -Name "FPRO" -IPAddress "192.168.0.20" -Port "21" -PhysicalPath $path4

Set-ItemProperty IIS:\Sites\FTPA -Name ftpServer.security.ssl.controlChannelPolicy -Value 1
Set-ItemProperty IIS:\Sites\FTPA -Name ftpServer.security.ssl.dataChannelPolicy -Value 1
