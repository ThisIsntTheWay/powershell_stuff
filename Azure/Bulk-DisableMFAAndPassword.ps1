$list = import-csv "C:\temp\Userliste.csv" -delimiter ";"
# Format: User;Password

Connect-MsolService
$list | % { # Might need adjustments later
	Write-Host "> $($_.user)" -f yellow
	$user = Get-MSOLUser -UserPrincipalName $_.user
	
	if ($user) {
		Set-MsolUser -UserPrincipalName $_.user -StrongAuthenticationRequirements @()
		Set-MsolUserPassword -UserPrincipalName $_.user -NewPassword $_.password -ForceChangePassword $false
	}
}