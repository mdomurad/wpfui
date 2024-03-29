param ($o, $n)
$Utf8Encoding = New-Object System.Text.UTF8Encoding $True

# Replace namespaces in .cs, .xaml, and .csproj files
Get-ChildItem * -Include *.cs, *.xaml, *.csproj -Recurse |
    Foreach-Object {
        $content = ($_ | Get-Content) 
        $content = $content -replace $o, $n
        [IO.File]::WriteAllText($_.FullName, ($content -join "`r`n"), $Utf8Encoding)
    }