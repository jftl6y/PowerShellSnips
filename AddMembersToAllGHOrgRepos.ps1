param(
    [Parameter(Mandatory=$true)]
    $orgName,
    [Parameter(Mandatory=$true)]
    $userCsvFile
)
$userList = Import-Csv -Path $userCsvFile | Select-Object -ExpandProperty usernames
$repos = ConvertFrom-Json (gh repo list $orgName -L 100 --json name)
foreach ($repo in $repos) {
    $repoName = $repo.name
    $repoCollaborators = gh api -X GET /repos/$orgName/$repoName/collaborators | ConvertFrom-Json | Select-Object -ExpandProperty login

    foreach ($user in $userList) {
        if ($repoCollaborators -contains $user) {
            Write-Host "Skipping $user in $repoName"
            continue
        }
        else {
            Write-Host "Adding $user to $repoName"
            #gh api -X PUT /repos/$orgName/$repoName/collaborators/$user
        }
        
    }
}
