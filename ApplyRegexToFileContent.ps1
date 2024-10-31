$inputFile = "C:\path\export-query.csv"
$outputFile = "C:\path\export-query-processed.csv"

$regex = '<a[^>]*?href=""[^"]*?dev\.azure\.com[^"]*?"[^>]*?>[\s\S]*?<\/a>'

$fileContent = Get-Content $inputFile -raw #| % { [System.Text.RegularExpressions.Regex]::Replace($fileContent, $regex, "---link replaced---",[System.Text.RegularExpressions.RegexOptions]::Multiline) }

$fileContent = [System.Text.RegularExpressions.Regex]::Replace($fileContent, $regex, "---link replaced---",[System.Text.RegularExpressions.RegexOptions]::Multiline)

Set-Content -Path $outputFile -Value $fileContent -Force