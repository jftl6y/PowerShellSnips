
# Define variables
$tenantId = ""
$clientId = "" 
$clientSecret = ""
$scope = "scope-guid/.default"  # Or another resource
$subscriptionKey = ""

# Token endpoint
$tokenUrl = "https://login.microsoftonline.us/$tenantId/oauth2/v2.0/token"

# Prepare body
$body = @{
    client_id = $clientId
    scope = $scope
    client_secret = $clientSecret
    grant_type = "client_credentials"
}

# Request the token
$response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body -ContentType "application/x-www-form-urlencoded"

# Output the access token
$token = $response.access_token


$headers = @{
    Authorization = "Bearer $token"
    "Ocp-Apim-Subscription-Key" = $subscriptionKey
}
$uri = "https://joscotwf1.azurewebsites.us:443/api/aerotest/triggers/When_a_HTTP_request_is_received/invoke?api-version=2022-05-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0" #&sig=SU47LMYofpS944YuWd5m7fKgjUf0uzOnxcfOvx73J3E"
$ret = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post
#$ret = Invoke-RestMethod -Uri "https://apim.edataexchange.com/testApi/catFact" -Headers $headers -Method Get

Write-Output $ret
