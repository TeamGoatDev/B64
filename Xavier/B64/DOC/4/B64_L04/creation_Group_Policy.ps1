Remove-ADOrganizationalUnit -Identity "OU=PROG,DC=DALTON,DC=B64" -Confirm:$false -recursive

New-ADOrganizationalUnit -Name PROG -Path "DC=DALTON,DC=B64" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name Niveau1 -Path "OU=PROG,DC=DALTON,DC=B64" -ProtectedFromAccidentalDeletion:$false
New-ADOrganizationalUnit -Name Niveau2 -Path "OU=Niveau1,OU=PROG,DC=DALTON,DC=B64" -ProtectedFromAccidentalDeletion:$false
