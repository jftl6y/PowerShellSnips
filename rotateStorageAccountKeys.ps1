# Login to Azure
#Connect-AzAccount -UseDeviceAuthentication

#set-azContext 6956ed15-2e18-4b8e-9db7-6a61647dedfb

# Get the storage account context
$storageAccounts = Get-AzStorageAccount

foreach ($storageAccount in $storageAccounts) {
    if ($storageAccount.AllowBlobPublicAccess -eq $true) {
        Write-Host "Storage account $($storageAccount.StorageAccountName) has public access enabled"
        set-AzStorageAccount -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName -AllowBlobPublicAccess $false    
    }
}
<#
foreach ($storageAccount in $storageAccounts) {
    $resourceGroupName = $storageAccount.ResourceGroupName
    $storageAccountName = $storageAccount.StorageAccountName

    # Rotate the keys
    New-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName -KeyName key1
    New-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName -KeyName key2
}
#>