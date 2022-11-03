try {
	write-host "start service" -f cyan
	Start-Service w32time
	
	Write-Host "sc triggerinfo" -f cyan
	cmd /c "sc triggerinfo w32time start/networkon stop/networkoff"
	
	Write-host "resync" -f cyan
	w32tm /resync /force
} catch {
	throw $_
}