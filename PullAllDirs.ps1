#write a script that will do a Git pull in each subdirectory
#of the current directory
#this is a good way to update all your git repos at once
#   
param(
    [Parameter(Mandatory=$true)]
    $dirPath ="./",
    [Parameter(Mandatory=$true)]
    $orgName
)
   $localRepos = Get-ChildItem $dirPath -Directory
   $ghRepos = ConvertFrom-Json (gh repo list $orgName -L 100 --json name)
   foreach ($repo in $localRepos) {
         if ($ghRepos.name -notcontains $repo.Name) {
              Write-Host "$repo does not exist in $orgName"
              #Remove-Item $repo.FullName -recurse -force
              Continue
         }
       Write-Host "Pulling $repo"
       Push-Location $repo
       git pull
       Pop-Location
   }
