# Http Server
$http = [System.Net.HttpListener]::new() 

# Hostname and port to listen on
$http.Prefixes.Add("http://localhost:8080/")

# Start the Http Server 
$http.Start()

# Log ready message to terminal 
if ($http.IsListening) {
    write-host " HTTP Server Ready!  " -f 'black' -b 'gre'
}


# INFINTE LOOP
# Used to listen for requests
while ($http.IsListening) {
    $context = $http.GetContext()

    if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/') {

        # decode the form post
        # html form members need 'name' attributes as in the example!
        $FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()

        # We can log the request to the terminal
        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'
        Write-Host $FormContent -f 'Green'

        try {
            $json = $formContent | ConvertFrom-Json
            [string]$response = "OK"
        } catch {
            [string]$response = "FAILURE: $($_)"
        }

        # the html/data

        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($response)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }
    
    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/kill') {
        Write-Warning "Killing server..."
        
        [string]$response = "BRB, killing myself" 

        #resposed to the request
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($response)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 

        $http.Stop()

        break
    }
}

Write-Host "Done" -f green
