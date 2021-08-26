# AzureAD_LastSignInTimeReport
Using an Azure AD App Registration and the Microsoft Graph API, we can pull the signInActivity of users and extract the value of "lastSignInDateTime". This would allow you to find users who have not signed into their account for a while, and you could determine whether or not the account/user is still active or not.

You will first need to complete the steps to create the Azure AD app registration. These steps are outlined in the PDF (Create App Registration for Microsoft Graph.pdf).

After the App Registration is configured, you will need to update the Powershell script with the AppID, TenantID, and Client_Secret. (These variables are defined in the first few lines of the script)
