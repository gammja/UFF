$path = "C:\Users\sp\Source\Repos\ChangeTracking\Source"

function IsIncluded($name)
{
  $exclude = "*\obj*", "*\bin*", "*\Properties", ".vs", "*\packages*"
  $mathes = $exclude | Where-Object {$name -like $_}
  $mathes.Count -eq 0
}

Get-ChildItem $path -File -Include *.cs, *.sln -Recurse `
 | Where-Object {IsIncluded $_.FullName} `
 | Format-Wide -Property Name -Column 1
 #Select-Xml