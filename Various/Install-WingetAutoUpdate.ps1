<#
	.SYNOPSIS
	Installs Winget-AutoUpdate by github.com/Romanitho
	
	.NOTES
	Make sure to edit $InstallParameters according to your needs.
	
	.AUTHOR
	Valentin Klopfenstein
#>

<# -------------------------
           VARIABLES
   ------------------------- #>
# For installation parameters, see:
# https://github.com/Romanitho/Winget-AutoUpdate/blob/main/Winget-AutoUpdate-Install.ps1
$InstallParameters = @{
	Silent 				= $true
	DesktopShortcut 	= $true
	InstallUserContext 	= $true
	NotificationLevel 	= "None"
	UpdatesInterval 	= "BiWeekly"
}

<# -------------------------
             MAIN
   ------------------------- #>
$tempFolder = "$env:TEMP\wingetInstallScript"

# Check if is not installed already
Write-Host "Checking for Winget-AutoUpdate..." -f cyan
try {
	Get-ScheduledTask Winget-AutoUpdate -ErrorAction SilentlyContinue | Out-Null
	
	Write-Host "> Already installed" -f green
	exit
} catch {
	Write-Host "> Missing" -f yellow
}

# Get latest release of Winget-AutoUpdate
''; Write-Host "Acquiring latest release of Winget-AutoUpdate..." -f cyan
try {
	$release = (irm https://github.com/Romanitho/Winget-AutoUpdate/releases.atom)[0].title
	$releaseDownload = "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/tags/$release.zip"

	Write-Host "> Latest release is: $release" -f cyan

	if (-not (Test-Path $tempFolder)) {
		mkdir $tempFolder | Out-Null
	}
	
	irm $releaseDownload -OutFile "$tempFolder\data.zip"
} catch {
	throw "Could not acquire latest release of Winget-AutoUpdate: $_"
}

# Install the thing
''; Write-Host "Attempting to install Winget-AutoUpdate..." -f cyan
try {
	Expand-Archive "$tempFolder\data.zip" "$tempFolder\data" -Force
	
	$target = Get-Item "$tempFolder\data\Winget-AutoUpdate*\Winget-AutoUpdate-Install.ps1"
	& $target.FullName @InstallParameters
	
	# Attempt cleanup
	''; Write-Host "Doing cleanup..." -f cyan
	try {
		Remove-Item $tempFolder -Recurse -Force
	} catch {
		Write-Host "Cleanup failed: $_" -f red
	}
	
	''; Write-Host "Installation is done." -f green
} catch {
	throw "Installation failed: $_"
}
