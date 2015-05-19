# Installation DNS
# doit être installé avant que le domaine soit créé.
Install-WindowsFeature DNS –IncludeManagementTools
Restart-Computer -Confirm:$true

