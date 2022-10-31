# Requires non-MFA enabled user
# Alternatively use an azure app

$localeID = 2055
$TimeZoneID = 4

$domain = "https://TARGET-admin.sharepoint.com"
Connect-PnPOnline -Url $domain -Credentials $cred
   
#Get All Site collections - Exclude: Seach Center, Mysite Host, App Catalog, Content Type Hub, eDiscovery and Bot Sites
$SitesCollections = Get-PnPTenantSite | Where -Property Template -NotIn ("SRCHCEN#0", "REDIRECTSITE#0", "SPSMSITEHOST#0", "APPCATALOG#0", "POINTPUBLISHINGHUB#0", "EDISC#0", "STS#-1")

Function Set-RegionalSettings
{ 
    [cmdletbinding()]
    Param(
        [parameter(Mandatory = $true, ValueFromPipeline = $True)] $Web
    )
  
    Try {
        Write-host -f Yellow "Setting Regional Settings for:"$Web.Url
        #Get the Timezone
        $TimeZone = $Web.RegionalSettings.TimeZones | Where-Object {$_.Id -eq $TimeZoneId} 
        #Update Regional Settings
		
		Write-Host "> Tz: $($TimeZone.Id)" -f yellow
		Write-Host "> Li: $($Web.RegionalSettings.LocaleId)" -f yellow

        #$Web.RegionalSettings.TimeZone = $TimeZone
        $Web.RegionalSettings.LocaleId = $LocaleId
        $Web.Update()
        Invoke-PnPQuery
        Write-host -f Green "`tRegional Settings Updated for "$Web.Url
    }
    Catch {
        write-host "`tError Setting Regional Settings: $($_.Exception.Message)" -foregroundcolor Red
    }
}

#Loop through each site collection
$i = 0
ForEach($Site in $SitesCollections)
{
	$i++
	Write-Host "$i/$($sitesCollections.count) - $($Site.Url)" -f magenta
    #Connect to site collection
    Connect-PnPOnline -Url $Site.Url -Credentials $Cred
  
    #Call the Function for all webs
    Get-PnPSubWeb -Recurse -IncludeRootWeb -Includes RegionalSettings, RegionalSettings.TimeZones | % { Set-RegionalSettings $_ }
}
