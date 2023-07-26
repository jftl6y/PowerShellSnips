param(
    [Parameter(Mandatory=$true)]
    $orgName,
    [Parameter(Mandatory=$true)]
    $webhookParametersFile
)
$webhookParameters = Get-Content -Path $webhookParametersFile |ConvertFrom-Json
write-host $webhookParameters.name
write-host $webhookParameters.active
write-host $webhookParameters.events
write-host $webhookParameters.webhookUrl #"https://webhook.site/0a0a0a0a-0a0a-0a0a-0a0a-0a0a0a0a0a0a"
write-host $webhookParameters.contentType

$repos = ConvertFrom-Json (gh repo list $orgName -L 100 --json name)
foreach ($repo in $repos) {
    $repoName = $repo.name
    $hooksUrls = gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/$orgName/$repoName/hooks | ConvertFrom-Json | Select-Object -ExpandProperty config | Select-Object -ExpandProperty url
    if ($hooksUrls -contains $webhookUrl) {
        Write-Host "Skipping $webhookUrl in $repoName"
        continue
    }
    else {
        Write-Host "Adding $webhookUrl to $repoName"
        gh api -X POST /repos/$orgName/$repoName/hooks -F name=$webhookParameters.name -F active=$webhookParameters.active -F events[]=$webhookParameters.events -F config[url]=$webhookParameters.webhookUrl -F config[content_type]=$webhookParameters.contentType
    }
}
