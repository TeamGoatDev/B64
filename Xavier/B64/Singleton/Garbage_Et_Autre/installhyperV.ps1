if($num){
    Rename-Computer -NewName "408P" -Force
    Add-WindowsFeature -Name hyper-v -IncludeAllSubFeature -IncludeManagementTools
    Add-WindowsFeature -Name RSAT-Hyper-V-Tools -IncludeAllSubFeature -IncludeManagementTools -Restart
}else{
    "assigne 'num'"
}