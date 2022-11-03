# Script stolen from somewhere but adjusted slightly by sdag/vk
# October 2022, tested and actually works

#Parameters
$OneDriveSiteURL = "https://tenant-my.sharepoint.com/personal/user_tenant_ch"
$DownloadPath ="D:\Archiv"
 
Try {
    #Connect to OneDrive site
    Connect-PnPOnline $OneDriveSiteURL -Interactive
    $Web = Get-PnPWeb
 
    #Get the "Documents" library where all OneDrive files are stored
	# This
    $List = Get-PnPList -Identity "Dokumente"
  
    #Get all Items from the Library - with progress bar
    $global:counter = 0
    $ListItems = Get-PnPListItem -List $List -PageSize 500 -Fields ID `
		-ScriptBlock { 
			Param($items)
			
			$global:counter += $items.Count
			Write-Progress `
				-PercentComplete ($global:Counter / ($List.ItemCount) * 100) `
				-Activity "Getting Items from OneDrive:" `
				-Status "Processing Items $global:Counter to $($List.ItemCount)"
	} 
    Write-Progress -Activity "Completed Retrieving Files and Folders from OneDrive!" -Completed
  
    #Get only specific subfolders
    $SubFolders = $ListItems | Where {
		($_.FileSystemObjectType -eq "Folder") -and `
		(($_.FieldValues.FileRef -like "*_raw_archiv_stuff*") -or `
		($_.FieldValues.FileRef -like "*_raw_archiv_stuff2*"))
		<#$_.FieldValues.FileLeafRef -ne "Forms"#>
	}
	
    $SubFolders | ForEach-Object {
        #Ensure All Folders in the Local Path
        $LocalFolder = $DownloadPath + ($_.FieldValues.FileRef.Substring($Web.ServerRelativeUrl.Length)) -replace "/","\"
        #Create Local Folder, if it doesn't exist
        If (!(Test-Path -Path $LocalFolder)) {
            New-Item -ItemType Directory -Path $LocalFolder | Out-Null
        }
		
        Write-host -f Yellow "Ensured Folder '$LocalFolder'"
    }
  
    #Get all files with a specific subfolder path
	<#$ListItems | Where {$_.FileSystemObjectType -eq "File"}#>
    $FilesColl = $ListItems | Where {
		($_.FileSystemObjectType -eq "File") <# -and `
		(($_.FieldValues.FileRef -like "*_raw_archiv_stuff*") -or `
		($_.FieldValues.FileRef -like "*_raw_archiv_stuff2*"))#>
	}
  
    #Iterate through each file and download
	$global:failCounter = 0
	$global:failIndex = [array]@()
    $i = 0; $FilesColl | ForEach-Object {
		Write-Progress `
			-PercentComplete ($i / ($FilesColl.Count) * 100) `
			-Activity "Downloading items:" `
			-Status "Processing item $i of $($FilesColl.Count)"
				
		write-host "> '$($_.FieldValues.FileRef)' " -nonew -f cyan
		try {
			$FileDownloadPath = ($DownloadPath + ($_.FieldValues.FileRef.Substring($Web.ServerRelativeUrl.Length)) -replace "/","\").Replace($_.FieldValues.FileLeafRef,'')
			Get-PnPFile -ServerRelativeUrl $_.FieldValues.FileRef -Path $FileDownloadPath -FileName $_.FieldValues.FileLeafRef -AsFile -force
			write-host "OK" -f green
		} catch {
			$failCounter++
			$failIndex += $_.FieldValues.FileLeafRef
			write-host "ERR" -f red
		}
    }
	
	Write-Host "Proces is done." -f green
	Write-Host "> Total indexed files: $($FilesColl.count)" -f cyan
	if ($failCounter -ne 0) {
		Write-Host "> Failed files: $failCounter" -f red
		Write-Host "  Use `$failIndex to get a list of these items." -f red
	}
}
Catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}