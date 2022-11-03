$basePath = '\\server\ProfilePath'
$inventory = gci $basePath

$inventory.Handle.Close()

$i = 0; $inventory.FullName | % {
    $i++
    Write-Host "$i/$($inventory.count) - $($_)" -f Yellow
    $t = "$($_)\NTUSER.dat"

    & reg load HKLM\TEMPHive $t

    $path = "HKLM:\TEMPHive\Software\ODBC\ODBC.ini"
    if (Test-Path $path) {
        & reg export ($path -replace ":", "") "C:\temp\regs\$($_.Split("\")[-1]).reg"
    } else {
        Write-Host "> Skipping" -f DarkGray
    }

    [gc]::collect()
    Start-SLeep -s 1
    & reg unload HKLM\TEMPHive
}

# Adjust things
gci "C:\temp\regs" | ? name -ne "backup" | % {
    Write-Host "> $($_.FullName)"

    #(Get-Content $_.FullName -Raw) -Replace [regex]::escape("HKEY_LOCAL_MACHINE\TEMPHive"), [regex]::escape("HKEY_CURRENT_USER") | `
     #   Out-File $_.FullName -Encoding UTF8

    $tPath = ($_.FullName).Split("\")
	
	# EDIT THIS
    $name = $_.Name -replace ".DOMAIN.V2", ""
	
    Move-Item $_.FullName "C:\temp\$name"
}

