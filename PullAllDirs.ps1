#write a script that will do a Git pull in each subdirectory
#of the current directory
#this is a good way to update all your git repos at once
#   
param(
    [Parameter(Mandatory=$true)]
    $dirPath ="./"
)
   $repos = Get-ChildItem $dirPath -Directory
   foreach ($repo in $repos) {
       Write-Host "Pulling $repo"
       Push-Location $repo
       git pull
       Pop-Location
   }
