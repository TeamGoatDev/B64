Param ( $Pays="Québec", $Ville1="St-Bruno", $Ville2="St-Bruno", $Ville3="Montréal")

$txt = "C:\Users\Tech\Desktop\UO.txt"
$csv = "C:\Users\Tech\Desktop\output.csv"

$header = "Nom_d_UO_parent;"+"Nom_d_UO_a_creer;"+"Description;"

Set-Content $csv $header

(Get-Content $txt) | Foreach-Object {    $_  -replace 'pays', $Pays `        -replace 'ville1', $Ville1 `        -replace 'ville2', $Ville2 `        -replace 'ville3', $Ville3    } | Add-Content $csv