﻿Param ( $Pays="Québec", $Ville1="St-Bruno", $Ville2="St-Bruno", $Ville3="Montréal")

$txt = "C:\Users\Tech\Desktop\UO.txt"
$csv = "C:\Users\Tech\Desktop\output.csv"

$header = "Nom_d_UO_parent;"+"Nom_d_UO_a_creer;"+"Description;"

Set-Content $csv $header

(Get-Content $txt) | Foreach-Object {