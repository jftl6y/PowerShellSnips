
# Define variables
$tenantId = "5310815f-d7b8-4c10-9879-9eccf368d822"
$clientId = "2bbad271-5009-4f68-9637-ab302af8b5c1" #"a865f57e-3a9b-46dd-9278-edd8a2b7b575"
$clientSecret = "Jcf0fOUroW3Fa93~-1m_o17.~z0HzF8Vbo" #"9QYD.0~QvhPFpL.~4.hkCgTatcKI2yfII4"
$scope = "a865f57e-3a9b-46dd-9278-edd8a2b7b575/.default"  # Or another resource
$subscriptionKey = "6b26461c5fbf41b2ba9fa06dc09e7682"

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
