# Invoke-GetWithClientCert.ps1
# PowerShell script to send a REST GET request with a client certificate

param(
    [string]$Uri = "https://apim.edataexchange.com/testApi/weatherForecast",
  #  [string]$PfxPath = "c:\test\apim_edataexchange_com.pfx", # Path to PFX file (optional)
    [string]$PfxPassword = "Ouu84j@@7", # Password for PFX file (optional)
    [string]$CertThumbprint = "f5af3b07a0f9664e7cc28f1f573c14315cb9a641" # Thumbprint for cert store (optional)
)

# Load certificate from PFX file if provided
if ($PfxPath) {
    $securePassword = if ($PfxPassword) { ConvertTo-SecureString -String $PfxPassword -AsPlainText -Force } else { $null }
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    if ($securePassword) {
        $cert.Import($PfxPath, $securePassword, 'DefaultKeySet')
    } else {
        $cert.Import($PfxPath)
    }
}
# Or load certificate from store by thumbprint
elseif ($CertThumbprint) {
    $cert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Thumbprint -eq $CertThumbprint }
    if (-not $cert) {
        Write-Error "Certificate with thumbprint $CertThumbprint not found in CurrentUser\My store."
        exit 1
    }
}
else {
    Write-Error "You must provide either a PfxPath or a CertThumbprint."
    exit 1
}

# Send the GET request with the certificate
try {
    $response = Invoke-RestMethod -Uri $Uri -Method Get -Certificate $cert
    Write-Output $response
} catch {
    Write-Error $_
}
