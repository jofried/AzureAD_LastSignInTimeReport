# AzureAD_LastSignInTimeReport
Using an Azure AD App Registration and the Microsoft Graph API, we can pull the signInActivity of users and extract the value of "lastSignInDateTime". This would allow you to find users who have not signed into their account for a while, and you could determine whether or not the account/user is still active or not.

You will first need to complete the steps to create the Azure AD app registration. These steps are outlined in the PDF [Create App Registration for Microsoft Graph.pdf](https://github.com/jofried/AzureAD_LastSignInTimeReport/blob/main/Create%20App%20Registration%20for%20Microsoft%20Graph.pdf).

After the App Registration is configured, you will need to update the Powershell script with the AppID, TenantID, and Client_Secret. (These variables are defined in the first few lines of the script)

The script will output the results inline, as well as, generate a CSV file with the results. The CSV file will be save under the "C:\temp\" directory, so please make sure this filepath exists. The CSV file can be opened in Excel to sort and filter the results to find users that have not logged in since a given time.
