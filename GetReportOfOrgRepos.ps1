param(
    [Parameter(Mandatory=$true)]
    $orgName
)
$repos = ConvertFrom-Json (gh repo list $orgName -L 2000) 
#| where-object { $_.name -match "terraform-.*-avm-.*" } | select-object name, visibility, url, description
foreach ($repo in $repos) {
    $repoName = $repo.name
    
   # Write-Host "Cloning $repoName"
    #gh repo clone $orgName/$repoName
    #--jq '. | test("terraform-.*-avm-.*")'
}