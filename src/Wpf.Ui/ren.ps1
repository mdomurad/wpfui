
$oN = "Wpf.Ui"
$nN = "BB.Wpf.Ui"
$oS = "/wpfui/"
$nS = "/bbwpfui/"

$Utf8Encoding = New-Object System.Text.UTF8Encoding $True

# Function to process each line, skipping lines that start with comments
function Process-Line {
    param ($line)
    if ($line -notmatch '^\s*//') { # Check if the line does not start with //

        return $line -replace $oN, $nN
    } else {
        return $line
    }
}

function Update-AssemblyInfo {
    param ($line)
    if ($line -notmatch '^\s*//') { # Check if the line does not start with //

        return $line -replace $oS, $nS 
    } else {
        return $line
    }

    }

# Replace namespaces in .cs, .xaml, and .csproj files, skipping comment lines
Get-ChildItem * -Include *.cs, *.xaml, *.csproj -Recurse |
    Foreach-Object {
        $content = Get-Content $_.FullName
        $newContent = $content | ForEach-Object { Process-Line $_ }
        [IO.File]::WriteAllText($_.FullName, ($newContent -join "`r`n"), $Utf8Encoding)
    }

#Update AssemblyInfo.cs
Get-ChildItem * -Include AssemblyInfo.cs -Recurse | # Include AssemblyInfo.cs
    Foreach-Object {
        $content = Get-Content $_.FullName
        $newContent = $content | ForEach-Object { Update-AssemblyInfo $_ }
        [IO.File]::WriteAllText($_.FullName, ($newContent -join "`r`n"), $Utf8Encoding)
    }