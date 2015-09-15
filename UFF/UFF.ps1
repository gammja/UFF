function IsIncluded($name)
{
  $exclude = "*\obj\Debug*", "*\bin\Debug*", "*\Properties"
  $mathes = $exclude | Where-Object {$name -like $_}
  $mathes.Count -eq 0
}

$path = "C:\Users\sp\Source\Repos\ChangeTracking\Source"

$ns = @{'e' = 'http://schemas.microsoft.com/developer/msbuild/2003'}
$used = Get-ChildItem $path -File -Include *.csproj -Recurse `
		 | Select-Xml '//e:Compile/@Include' -Namespace $ns `
		 | ForEach-Object {$_.Node.'#text' } `
		 | Split-Path -Leaf

Get-ChildItem $path -File -Include *.cs -Recurse -Exclude $used  `
 | Where-Object {IsIncluded $_.FullName} `
 | Format-Wide -Property FullName -Column 1