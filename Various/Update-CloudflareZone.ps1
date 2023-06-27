$ApiToken = "..."
$LogFile = "cloudflare_update.log"
$DnsRecord = "..."

function To-Log {
    Param(
        $message = $null,
        $level = "info"
    )

    switch ($level) {
        "info" {
            $color = "cyan"
        } "error" {
            $color = "red"
        } "warn" {
            $color = "yellow"
        } "success" {
            $color = "green"
        } default {
            $color = "white"
        }
    }

    $logMessage = (Get-Date -f "[dd/MM/yyyy - HH:mm:ss]") + " - [$($level.toUpper())] $message"

    Write-Host $logMessage -f $color
    $logMessage >> $LogFile
}

# --------------------------------------------------------

$dnsZone = $DnsRecord.Substring($DnsRecord.IndexOf(".") + 1)
To-Log "Starting a new run for: $DnsRecord ($dnsZone)"

$headers = @{
    "Authorization" = "Bearer $ApiToken"
    "Content-Type" = "application/json"
}

try {
    # Get IP
    To-Log "Getting IP..."
    $ip = irm https://checkip.amazonaws.com
    To-Log "> Got: $ip"

    # Get Zone ID
    To-Log "Getting zone ID..."
    $uri = "https://api.cloudflare.com/client/v4/zones?name=$dnsZone&status=active"
    $response = irm $uri -Headers $headers

    $zoneId = $response.result.id
    if (-not $zoneId) {
        throw "Did not get any zone ID."
    }

    To-Log "> Got zone ID: $zoneId"

    # Identify target record
    $uri = "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records"
    $response = irm $uri -Headers $headers

    $zones = $response.result | select id, name
    $recordId = ($zones | ? name -eq $DnsRecord).id

    # Patch IPv4
    $flareBody = @{
        type = "A"
        name = $DnsRecord
        content = $ip
        ttl = 3600
        proxied = $false
    } | ConvertTo-Json

    if (-not $recordId) {
        # Record does not yet exist
        To-Log "Creating record '$DnsRecord'..." "warn"

        irm $uri -Method POST -Headers $headers -Body $flareBody | Out-Null
        To-Log "Created record '$DnsRecord' with IP '$ip'." "success"
    } else {
        # Record exists, update
        To-Log "Updating record '$DnsRecord'..." "warn"

        $uri = $uri + "/$recordId"
        irm $uri -Method PUT -Headers $headers -Body $flareBody | Out-Null
        To-Log "Updated record '$DnsRecord' with IP '$ip'." "success"
    }

} catch {
    To-Log "Error on '$uri': $_" "error"
    exit 1
}
