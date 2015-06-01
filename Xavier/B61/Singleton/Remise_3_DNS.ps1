#Xavier Hudon-Dansereau
#Script à lancer sur le serveur InterneUn
#Crée les enregistrement dans le dns

Add-DNSServerForwarder @("10.57.4.28","10.57.4.29")
#Web
Add-DnsServerResourceRecordA -Name "PRO" -ZoneName "PRO.CEGAT.PRO" -IPv4Address "192.168.0.20"
Add-DnsServerResourceRecordA -Name "SECPRO" -ZoneName "SECPRO.CEGAT.PRO" -IPv4Address "192.168.0.20"
#DNS
Add-DnsServerResourceRecordA -Name "FDPRO" -ZoneName "FDPRO.CEGAT.PRO" -IPv4Address "192.168.0.20"
Add-DnsServerResourceRecordA -Name "FPPRO" -ZoneName "SECPRO.CEGAT.PRO" -IPv4Address "192.168.0.20"



$adGroup = "grFTP"
$nomDom = "OU=USERS,DC=CEGAT,DC=PRO"
$nomDNS = (Get-ADDomain).DNSRoot
$mdp = "AAAaaa111"

#Group FTP
New-ADGroup -Name $adGroup -Path $nomDom

#User FTP
addUser "FTP1"
addUser "FTP2"
addUser "FTP3"


function addUser($nom){
    New-Item -Path "C:\_CEGAT_PRO\FTPA\$nom" -ItemType directory -Force
    icacls "C:\_CEGAT_PRO\FTPA\$nom" /inheritance:r
    icacls "C:\_CEGAT_PRO\FTPA\$nom" /grant "Administrateurs:(CI)(OI)(F)"
    icacls "C:\_CEGAT_PRO\FTPA\$nom" /grant "Système:(CI)(OI)(F)"
    icacls "C:\_CEGAT_PRO\FTPA\$nom" /grant "${nom}:(CI)(OI)M"
    New-ADUser -Name $nom `
        -Path $NomDom `
        -HomeDrive "C:\" `
        -HomeDirectory "\\CEGAT\_Perso\Matricule" `
	    -AccountPassword (ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force) `
	    -PasswordNeverExpires $true `
	    -Enabled $true

    Add-ADGroupMember $adGroup $nom

}