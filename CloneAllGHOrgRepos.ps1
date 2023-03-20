param(
    [Parameter(Mandatory=$true)]
    $orgName
)
$repos = ConvertFrom-Json (gh repo list $orgName -L 100 --json name)
foreach ($repo in $repos) {
    $repoName = $repo.name
    if (Test-Path $repoName) {
        Write-Host "Skipping $repoName"
        continue
    }
    Write-Host "Cloning $repoName"
    gh repo clone $orgName/$repoName
}



