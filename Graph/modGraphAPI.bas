Attribute VB_Name = "modGraphAPI"

'Obtains an authorization token from MS graph using an app registration
Function GetGraphAuthToken() As String
    Dim httpObj As Object
    Dim applicationID As String, clientSecret As String, tenantID As String, tokenReqBody As String, tokenUrl As String
    
    Set httpObj = CreateObject("WinHttp.WinHttpRequest.5.1")
    
    'General variables, edit if necessary
    applicationID = ""
    clientSecret = ""
    tenantID = ""
    
    'Reqeust body and URL
    tokenReqBody = ("client_id=" & applicationID & "&resource=https://graph.microsoft.com/&grant_type=client_credentials&client_secret=" & clientSecret & "")
    tokenUrl = "https://login.microsoftonline.com/" & tenantID & "/oauth2/token"
    
    'Debug stuff
        'Debug.Print "URL: " & tokenUrl
        'Debug.Print "Body: " & tokenReqBody
    
    'Attempt to acquire token
    With httpObj
        .Open "POST", tokenUrl, False
        .setRequestHeader "Content-Type", "application/x-www-form-urlencoded" 'Endpoint expects request as form.
        .send tokenReqBody
        
        Dim resp As Object
        If httpObj.Status = "200" Then
            Set resp = JsonConverter.ParseJson(httpObj.ResponseText)
            
            Debug.Print "> Got access token."
            
            'Return token
            GetGraphAuthToken = resp("access_token")
        Else
            'Error handling
            Set resp = ParseJson(httpObj.ResponseText)
            
            Err.Raise Number:=vbObjectError + 513, _
                Description:="Could not acquire auth token for MS Graph: " & resp("error_description")
        End If
    End With
End Function

'Returns a list of users, handles data paging
Function GetUsers() As Object
    Dim httpObj As Object
    Dim authorizatonToken As String, requestUrl As String, requestUrlParams As String
    
    Set httpObj = CreateObject("WinHttp.WinHttpRequest.5.1")
    
    authorizatonToken = GetGraphAuthToken
    
    'requestUrlParams is optional, but recommended.
    'See the following doc for query params: https://learn.microsoft.com/en-us/graph/query-parameters#odata-system-query-options
    
	'Edit params as needed
	requestUrlParams = "?$count=true&$filter=onPremisesExtensionAttributes/extensionAttribute4 ne null&$select=onPremisesExtensionAttributes,onPremisesSamAccountName,givenname,surname,jobtitle,mail,businessPhones"
    requestUrl = "https://graph.microsoft.com/v1.0/users" & requestUrlParams
    
    'Debug.Print "Auth token: " & authorizatonToken
    
    'Obtain user list
    With httpObj
        .Open "GET", requestUrl, False
        .setRequestHeader "Authorization", "Bearer " & authorizatonToken
        .setRequestHeader "ConsistencyLevel", "eventual" 'Required for $filter URL param
        .send
        
        Dim resp As Object
        If httpObj.Status = "200" Then
            Dim output As New Collection
            Set resp = JsonConverter.ParseJson(httpObj.ResponseText)
            
            'We only need the 'value' property from our response
            For i = 1 To resp("value").Count
                output.Add resp("value")(i)
            Next
            
            'Check if paged data is present
            'See: https://learn.microsoft.com/en-us/graph/paging
            While resp.Exists("@odata.nextLink")
                Dim pageLink As String
                pageLink = resp("@odata.nextLink")
				
                Debug.Print "> Paged data: " & pageLink

                'Assemble output collection using paged data
                With httpObj
                    .Open "GET", pageLink, False
                    .setRequestHeader "Authorization", "Bearer " & authorizatonToken
                    .send

                        Set resp = JsonConverter.ParseJson(httpObj.ResponseText)
                        If httpObj.Status = "200" Then
                            For i = 1 To resp("value").Count
                                output.Add resp("value")(i)
                            Next
                        Else
                            Err.Raise Number:=vbObjectError + 513, _
                                Description:="Could not retrieve paged user list data from MS graph: " & resp("error")("message")
                        End If
                End With
            Wend
            
            Debug.Print "> Got " & output.Count & " users."
    
            'To access user props: output(<index>)("<property>")
            Set GetUsers = output
        Else
            Set resp = ParseJson(httpObj.ResponseText)
            
            Err.Raise Number:=vbObjectError + 513, _
                Description:="Could not obtain user list from MS Graph: " & resp("error")("message")
        End If
    End With
End Function
