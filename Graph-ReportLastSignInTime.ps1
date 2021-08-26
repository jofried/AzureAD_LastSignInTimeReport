#######################################################################
#######################################################################
#############--Please update the script variables below--##############
#App ID of app registration
$AppId = "<Application (client) ID of App Registration>" 

#Client Secret for App Registration
$client_secret = '<Client Secret Value>'

#Tenant ID of app registration
$TenantId = "<Directory (tenant) ID of App Registration>"
#######################################################################
#######################################################################




 
#######################################################################
#Get access token for App Registration
#######################################################################
$body = @{
    client_id     = $AppId
    scope         = "https://graph.microsoft.com/.default"
    client_secret = $client_secret
    grant_type    = "client_credentials"
}

try 
{
    $tokenRequest = Invoke-WebRequest -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body -UseBasicParsing -ErrorAction Stop
}
catch 
{ 
    Write-Host "Unable to obtain access token" -ForegroundColor Red; return 
}

$token = ($tokenRequest.Content | ConvertFrom-Json).access_token

#######################################################################
#Auth header Details
#######################################################################
$authHeader = @{
   'Content-Type'='application\json'
   'Authorization'="Bearer $token"
}

#######################################################################
#Execute the Microsoft Graph query
#######################################################################
$SignInActivity = Invoke-WebRequest -Headers $AuthHeader -Uri "https://graph.microsoft.com/beta/users?`$select=displayName,userPrincipalName,signInActivity"

$result = ($SignInActivity.Content | ConvertFrom-Json).Value
$result  | Select-Object DisplayName,UserPrincipalName,@{n="LastLoginDate";e={$_.signInActivity.lastSignInDateTime}}

#######################################################################
#Export results to CSV (Folder "C:\temp" must be created)
#######################################################################
$path = "c:\temp\SignInActivity_$(get-date -Format MM-dd-yyyy--HH.mm.ss).csv"
$result | Select-Object DisplayName,UserPrincipalName,@{n="LastLoginDate";e={$_.signInActivity.lastSignInDateTime}} | Export-Csv -Path  $path-NoTypeInformation -Encoding UTF8 -UseCulture
