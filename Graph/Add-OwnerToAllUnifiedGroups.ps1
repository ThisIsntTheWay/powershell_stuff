# Add User as owner to ALL M365 groups in a tenant
try {
    $user = Get-Graphuser "username"
    $url = "https://graph.microsoft.com/beta/groups?`$filter=groupTypes/any(i:i eq 'unified')"
    $a = irm -Headers $authHeader -Uri $url
    
    $groupList = @()
    $a.value | select id,mail,displayname | % {
        $groupList += $_
    }
    
    if ($a."@odata.nextLink") {
        do {
            Write-Host "Paged data!" -f yellow
    
            try {
                $a = irm -Headers $authHeader -Uri $a."@odata.nextLink" 
                $a.value | select id,mail,displayname | % {
                    $groupList += $_
                }            
            } catch {
                Write-Host "Error: $_" -f red
            }
        } while ($a."@odata.nextLink") 
    }
    
    $grouplist | % {
        Write-Host $_.mail -f yellow
    
        $uri = "https://graph.microsoft.com/beta/groups/$($_.id)/owners/`$ref"
        try {
            $body = (@{
                "@odata.id" = "https://graph.microsoft.com/beta/users/$($user.id)"
            } | ConvertTo-Json)
            irm -Headers $authHeader -Method POST -body $body -ContentType application/json -Uri $uri | Out-Null
        } catch {
            Write-Host "Error: $_" -f red
        }
    }    
} catch {
    throw $_
}
