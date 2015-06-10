$path = "C:\_backup\manifest.xml"

$xml = New-Object -TypeName XML
$xml.Load($path)
#ou
#[xml]$xml = Get-Content $path

$names = $xml.GetElementsByTagName("GPODisplayName")
foreach($name in $names){
    $name.InnerText
}