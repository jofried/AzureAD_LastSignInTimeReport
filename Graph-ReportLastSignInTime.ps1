##############################################################################################
#
# This script is not officially supported by Microsoft, use it at your own risk.
# Microsoft has no liability, obligations, warranty, or responsibility regarding
# any result produced by use of this file.
#
##############################################################################################
# The sample scripts are not supported under any Microsoft standard support
# program or service. The sample scripts are provided AS IS without warranty
# of any kind. Microsoft further disclaims all implied warranties including, without
# limitation, any implied warranties of merchantability or of fitness for a particular
# purpose. The entire risk arising out of the use or performance of the sample scripts
# and documentation remains with you. In no event shall Microsoft, its authors, or
# anyone else involved in the creation, production, or delivery of the scripts be liable
# for any damages whatsoever (including, without limitation, damages for loss of business
# profits, business interruption, loss of business information, or other pecuniary loss)
# arising out of the use of or inability to use the sample scripts or documentation,
# even if Microsoft has been advised of the possibility of such damages
##############################################################################################

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
