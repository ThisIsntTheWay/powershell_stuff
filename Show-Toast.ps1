Param(
    [parameter(Mandatory = $false)]
        [bool]$quiet = $false
)

<# ---------------------
            VARS
   --------------------- #>
$b64Warn  = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAMAAAD04JH5AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAbFBMVEUAAAD/tgD+uAD/uAD+uAD+twD/uAD/uAD/uAD/uAD/twD+twD/twD/uAD/uAD/uAD/vAD+zAD/vgD82wD84QD+4gD+4wD53gDkywDgyADhyAA0LgAaFwAbGQAAAAD+vwD83AD84gD/uAD/twC2sF0YAAAAEHRSTlMAAAAAXBK+Wve8vBS7Z/XMMGBwqAAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAMISURBVHjaxdkLVgIxDIXhYRDfLxQQUURx/3sUURG0Te5N26Qb4D/fYTrTtOtK1qA/OuoHXdzqR8fHoz7u9wfDk9PTk+EgEODs9vYsjuATYDwOJOhH53f393fnUQRbgMkkjmALMJmEEXwDxBF8A4QR7ACiCHYAQQR7ADEEewAhBAcAEQQHAAEEfwD8Cf4AuBP8A/Am+AfgTJAA8CVIALgSJAE8CZIAjgQZAD+CDIAbQRbAiyAL4EQgAPgQCAAuBCKAB4EI4ECgALQnUACaE6gArQlUgMYEAEBbAgCgKQEE0JIAAmhIAAK0IwABmhHAAK0IYIBGBARAGwICoAlBGmA6266pA0ES4GH+uNisx/lDc4IkwHT+9LzcrOen+bQ1QRJgtli+bNdyMWtMkP4HSAGVCdKPgBhQlSCzB4gBVQkye4AcUJEgtwnKARUJcpugElCNIPsWUAKqEWTfAlpAJYL8a1ALqESQfw2qAVUIhO8ANaAKgfAdoAdUIJA+hPSACgTShxAQUEwgfgkCAcUE4pcgElBIIH8KIwGFBPKnMBRQRKCcBaCAIgLlLIAFFBBohyEsoIBAOwyBAWYC9TQIBpgJ1NMgGmAk0I/DaICRQD8OwwEmAmAeAAeYCIB5AB5gIEAGIniAgQAZiBABNAE0ESICaAJoIsQEkATYSIwJIAmwkRgVQBGAM0EqgCIAZ4JcAEGADkW5AIIAHYqSATABPBUmA2ACeCrMBoAE+FicDQAJ8LE4HQAREPcCdABEQNwL8AEAAXMxwgcABMzFiDSutxJQN0PChYWZgLoZEq5srAQcgGnJBCSAZYkEDgAygQOASMAD8H9CkYAGMDyGEgENYNiIRAIawLAVSwT8P8AakCHgHwFzQJLAsAeYA5IEhj3AHpAgsGyC9oAEgWUTtD6GKQLbW8C2ESUJjG8B01acInB5DUoELq9BgSAA4JAgAOCAIARgnyAEYI8gCOCXIAhgRxAG8EMQBvBDEAfwRdBdXK5e34LW6+ryoru6Xo3D1ur6qrtZr9/D1np98wEwbZzphmAk2QAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNS0wMy0xOVQwODo0NDozMCswODowMGBxxKIAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTUtMDMtMTlUMDg6NDQ6MzArMDg6MDARLHweAAAAAElFTkSuQmCC"
$b64Info  = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAMAAAD04JH5AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAACYVBMVEUAAAAASIsARosAQIwAP4YAX5EAS40ASpAATYoAVIwAVooATIsATYsAUZAATYkASJYAQokAT4sATIgATYwATI0ATokAQ4gAS4sATowASogAalwATIwASYwATIoARogATosAR4kASosATogATI4AfzQAS4wATYsATYoATYoATYsATYsATIsATYsATIsATIoATIoATIoATIoATIoATIkATIkATIkATIkATIkATIsATYsATIsATIoATIoATIkATYsATo4AUJEATIsATIoATIoATIoATowAUZEATIoATIoATYkATYoATIoATIoATIoAT48ATIoATYoATIoATIoAT44ATIoATIoATYsAUZMAUZIATYoATYoATIoATYsATYoATIsATIoATYsATYsATYsATIsATYoATIoATYoATIsATIsATIoAT48ATIoASIwATYsATIoAT48ATIsATYsATYoATYsAS4oATIoATo0ATYsATIoAUJAATYoATYoATIoATYsATo0AR4oATYsATIoATIsATIoAS4sATIkATYoATIoATYoATYkATIoATowAUJEAS4sATIoAT48AUpQAVpsAWaEAXKYAXqkAYK4AYrEAYa4AVpoAY7MAab0AbsYAcs4AdNEAddMAdtUAd9YAd9cAeNgAd9gAVZkAZrkAb8kAVZoAYK0Aa8EAc9AAdtYAab4Ac88AU5YAYa8Ab8gAbsgAccsAYrAAXagAdtQAX6wAcs0AVJcAaLwAX6sAddQAUZEAZ7oAasAAUJAAdtcDedcZhNschtvK4/fl8fvj8Pv///8AYbAAUZIAVJg+0aoaAAAAkHRSTlMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQsRFBkcCBUsTmyGnbHDzNzk4wcdR3akzej0/Qppo9ny/qJmBCFjreT7CjyP1/oNqev+/gtOsPIFPKfx8DoghufmCVjL/ZECQ8b+C2yQ9CGq+yy7/i3Cwhb8AvXjIcUIBOUJPQOu8f4FnPwqu43nAAAAAWJLR0QAiAUdSAAAAAlwSFlzAAALEgAACxIB0t1+/AAABdZJREFUeNrtm/dbE0kYx8EazYoNewH1pJkEpEgLIIqCYFDqKaCGckgRUQRBsZeze2lEEgib2aUnhN6DIiin91ddDAkXIIHdSdjhuYfvzzx5P8y8887sW5ycVrQiODmvOurh6eXtY5C3l6fH0VXOzJlefYzD5fn6HfcPCAw6ERx8IigwwP+4ny+Pyzm2eqkx1qwNCQ0L50dERp0UiSVSWY3coE8yqUQsOhkVGcEPDwsNWbtmqayvWx/NPXU65szZWqlCWVevasDVgDCIVOMNqvo6pUJae/ZMTGwcN3r9uiUwzzoXn3BekNgoa2pW4QarJJglkiQIXNXcJGtMFJxPiD/HcvDSb7hwMSk5paW1rV1DzDE9C4PQtLe1tqQkJ128sMFxW+G8MZWXlv67VNsBCLCoCNChlV5KT+OlbnSQS7IvZ2Rm6Tq7cArWTQx4d6cuK5MXzXbE3l+5ek2ok/cAEtAQCXrkumx+zhV7fQHblJv3h6iXpnkTQq8oPy93E2bX6l8vKCzq66Jvfhqhq6+osOA6/D64bM4tFoqV/VDmjQj9SrGwOHezC+S/f6PkZunAILR5I8LgQOnNkhtQi4Ddui0YGsbtsm8gwIeHBLdv0XeELVs5ZXckXXaaNyJ0Se6UcbZuoRn3t5VX3B1pd4B9A0H7yN2K8m207geX7ZVV9xSjDrFvIBhV3Kuq3O5Cx/79av2YBjhMmjF99X3qBAb7D0RaNXCg1FrRA8oErjsqq0WfgYP1WVRducOViv2dWHmVXgscLq2+qhzbSeX8P6z4MqZ2PIB67EvFQwrxgB1d9khB0f/GTaLoiYpHZYtf0Lse+z4ZGaX2i18nJo2a+Ert70dHnvg+3rXYASh5KqEYf8Ynvn2fMuj7t4lxihFJ8rRkkaOAPXs+RDX+jk9O/W3U1OQ41ag89PzZgm7AflFcOkw1/tEHAORwafGLBdxg954C4QAOlg4A4APCgj27F9iAQjH1+x8GgBwUF9reBNbLvCIl9QsIBgCQyqK8lzZeqnv3Xc3v6wdLCwD6+/7M2bfXRgjii+i8QGgfQ9NJEPGth6P9GC+7l1ZwpRuITPqRzcP2WwE4kJqp66H3BKEXis1L0KPLTD0w3/5Bt4wsOWBE8qwMt4PzPeBVGt0FgH2h9ejSXs33Aux1eidgSJ3pr+fFAtabpJ/dJDP2ye6fSW/mxgJWfLIUp/tLUE74KyBLk+PnALiyElK0BM3fgTyGhvyBNiWB5TonCL1t6aD7/0MFIqM6Wt7OCUZsrqCV9gZAheJptQq4swDcsbjENoI5AKItMQ5zt1yAkNjGdiZXoL0xNsRyCbDQGJmGSQCNLCbUMhRgYe+aCCYBiKZ3YRYAh7BwfTPJJADZrA/HDlm4AL9WBZgEAKpavoUTYJwI+mHQPgBcGsH5bw8wbqSCYBaAUERyLQB4UUqmAZRRPAsA3/d1JLMAZN173xmAw0f8RPVMA9SL/I4cNh+CDx/F9A+BfQBAJf74wXwMMA9/SQPTAA0Sfw/zHrA8AyBOoZ0AuDTA0/woYXkFytRMA6hlgV5mAMw76BPJNACoCfI2bwHmEywnmAYg5ME+KwDLB8A7qAagdELkxxB5IEIeipFfRsivY+QPkmXwJEP+KEX9LEf+YYL80wz5xyn6z3N2yGmGExT/zE5QuGOn/kKaokGepIJL08EDzE/TwSQq4QGsJCphUrXwAFZStTDJamgAq8lqiHQ9/ApYS9dDFCxgAWwULOiXbKBXwHrJhn7RChLAVtHKab8bT9jLxArYKts5sS5fo1e4hAKwXbh0+o2NuHSLvHiNvnyPvoEBeQsH+iYW9G08yBuZ0LdyoW9mQ9/Oh7yhEX1LJ/qmVvRtvegbm9G3dqNvbl8G7f3oBxzQj3iYhlzyYYdcftg/5GIc88nhZ6Mb85m+oHm/Bp26EQ06zYx6XUI26oV+2G0ZjPvNDDzGxc4feATMDDzaHvmsMYx81jIx8rkchl6Xxdjviv5v+hcqsnya2coFagAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNS0wMy0xOVQwODo0NDozMCswODowMGBxxKIAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTUtMDMtMTlUMDg6NDQ6MzArMDg6MDARLHweAAAAAElFTkSuQmCC"
$b64Error = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAMAAAD04JH5AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAACnVBMVEUAAACiIBOiHROfGRSkJR2hJAagJxOcKhOkJRKkJQ2oLhKkJBOjJBOjJBKjJROZJRSiIxGsLh+iIxOkJROkJRujJBCnIxSkJRGjJRSkJRSmJBKlJhujJRKjJBShIxKoKBbMQgCiIRSkJBKlJhihJxOlJRejIhOmJRCiJBbvYwChJROiJROjJRKkJRKkJROkJROjJBOjJBKjJBOjJROjJBOjJROiJROiJROiJBOiJROiJBOiJROiJROjJROjJBKjJROjJBOjJROiJBOjJROnJhOqJhOjJROjJROjJROjJROiJBOlJROqJxOjJROjJBOkJRGkJRKjJROjJROjJROoJhOkJROkJROjJROjJROnJhOkJBKkJROjJROkJROsJxOrJxOkJBKjJROkJROjJBOjJBGjJROkJROkJROjJROkJROjJROjJROkJBOjJBOjJROoJhOjJROhIRSjJBKjJROoJhOjJBOkJROjJROkJROkJRSjJROnJhOkJROjJROpJhOkJRKjJROjJBKnJhOiIxakJROjJROkJROjJROkJBOkJRKjJROjJBKkJROkJROkJRCjJROlJROjJBOqJhOiJROiJROoJhOjJROtJxO0KRO6KxS/LBTCLRTHLhTKLxTILhTDLRSzKRTALBTMMBTWMhXgNRXnNxbqNxbsOBbuOBbvORbwORbxORayKRPSMRXiNRXqOBbuORbGLhTaMxXpNxbXMxXoNxavKBPILxThNRXkNhXJLxTlNhXBLRTtOBbFLhTmNhawKBPVMhXELhTNMBWqJxPTMRWtKBPXMhXZMxWpJhPwOBXwOhfyTS7wPBr1dl781s/2hXDwOxj1dV395+P////+7+z2hG781c6rJxP+7uv2hnD+9PL+9fOxKBO7KxSpL/1QAAAAl3RSTlMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFCxEUGRwIFSxObIadscPM3OTjBx1HdqTN6PT9Cixpo9ny/qJmBCFjreT7CjyP1/oNTqnr/v4LsPIKBafx8Dog5+YJWMv9kQJDxv4LbJD0Iar7LLv+LcIW/AL14yHFCATlCgk9A67xB/4FnPydq8ipDQAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAZTSURBVHja7Zt3WxNZFMZxbVEwlrFh77pSlBIp0gIIioIgSAusggqyShERBEGx69rLbhpo6MkdeiCEKh1NAFGDBd39LJuAlJAB5k4SrruP50+emfxe5pZz7rnnGBj8tJ9GzWb8stPE1Mx8l9LMzUxNdv4yY/rQM3dbWFpZM/bY2NrZ73Vw2GtvZ2uzh2FtZWmxe6a+Zcya7ejk7MJ0dXPfx+ZwefysbKW9eMnjctj73N1cmS7OTo6zZ+mLPmeuh+f+A14HDwlycvPyCwqLhCKAq0wkLCosyM/LzREcOujl7ePpMXeOHvC0w75+R/wDivklpWXlKixQM9VfystKS/jFAf5H/HwP03T86ecdDQwKDhFUVIpF49HqMkTiygpBSHBQ4NF5uhuKGfNDWWHhv/GqqsEk8BERoLqKdyw8jBU6X0dT0vA4KyJSUiMtJ0H/rkEorZFERrBOGOkAv+Bk4KkoSXYtII0f+gy12ZJo5umTC7TE0xfGMH5n19XD4Yck1NexzzBiFtK1+vpnY+PiG6Tw+CEJ0ob4uNizhpTxixbHJERx8hop4QclNOZxohJiFi+ixl9yLvF8UtMryvhBCa+aks4nnltChY9dSPZvbhFqxVctiJZm/+QLGDR+6TKLlItcqZb4QQlS7sUUi2VLIff95alpl1rFOuArFYhbL6WlLofyDytWpmdcbmvUCV81F9suZ6SvXAHBN76S2d4hAjozUUd75hXjFTD8zi4d8pUKujrJK5izKj2z8zXQsb3uzExfRWoerF6TmtHeBXRuXe0ZqWtWk/E+V9PedIh0L0DU8SbtKgnfZHQi5VqbHvhKBW3XUqZ20GuvJ99obQR6scbWG8nX107hf4wTb3LFuH4E4GLuzUTjyT0Tdut2s1RPfNWu3Hz71qRuAbuTkNSiN75SQUtSwp1JFKxbHxvVJCR6UwYPI3xF2BQVu37dJAMQxyH0//LuHkgJsp5uOWF8wImbeBBodxnxeUR8We/bvndQCmTv+t72Er2B58Uz7k5watlgFHimgWgFyt5/UPR/hFEge/exX/HhPdEbjQ1/nDbaQByB3mOyiVaAiq+AUjDIVxArwKVs5j3COHUjxoquAxPxYRR850+gANRFs7CNBAI2hUZI6jU/gLx3iE9ewQhfqaBXcybi9ZKI0E2a/M00VmQ2wa91f1IooBSM4SsUn7oJ3siOZNE2ay7B+2GSWoIZ0NPXD6VAjd/f10MwC2olYfc1lyL2ILxm6h+cUgGpx2vCH2gIoD0M+kzsBKAUkHoYl34Oejh+L6D5BvOEWvwo1KNCXrDvOAFbDP1CqnCgpQKyD+JVIX6GW9SP4R6PBNXa/mPkP1W14JGH+rEd8/Sv0HZoYSZLhb+n2jTcSvcJqMS1UwDDxysDfOhbx46Ao3exWLvlBbdcxcXejmPHgO7kxRdptcAhtwsR38tprADM+XEJDrRQAMkHeMlj5zGTYBvm0l6KA+oKYPkAL213wbaNHkaeMAVlkG5mLAaaD0CZgPlk9JBiZOGaUw4oK6DAB+U5rhajAgwt3XJJBeOEKCp8gOe6WY7GRZiVex650wABjBJfGZy6W43OQsz6aT7J44gGjhof4PlPrUcEbN/BYBeQPQ+NA8rllPgAL2Azdmwf3oaePecUwoXcw/ZlYOALFT4AhZznz4a3IrqJDbcIUFPw9Ss1Piji2pgMC6CZ2k4UjEytgCJfGZTYmg4HJTQzu5dQOREiBZB8pTewMxsWgJnbv4A7k2sqgOUDkGVvPrwMsF0O2ZBJgfEK4Pl4tsMuLQQAmXzg2yj/24AcNoPwXxeg4yEwt88CKCehchnykS5D5BsR8q0YuTNC7o6RByToQzLkQSnysBz5wQT50Qz54RT98ZzueGCaExR/qycotmL7/5zeFM0l9RQN8iQV+jQd8kQl8lQt+mQ18nQ9+gsL5Fc2yC+tVNd2UUiv7Qw2HT+F9OLS4FfUV7fIL6/RX9+jL2BAXsKBvogFfRkP8kIm9KVc6IvZ0JfzIS9oRF/Sib6oFX1ZL/rCZvSl3eiL23+A8n70DQ7oWzy+N7mcQdjkMtjmc5oZja7NZ8hBDzU6CdE0Oo20eh1D1uqFvtntB2j3G2l49PHWbHgE09PwOHHLZxaf98+0tHxO1vT61zQ1vf4Qbb8/7f9m/wKaQLguFEq7qAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNS0wMy0xOVQwODo0NDozMCswODowMGBxxKIAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTUtMDMtMTlUMDg6NDQ6MzArMDg6MDARLHweAAAAAElFTkSuQmCC"
  
$icons = @{
    "info" = $b64Info
    "warn" = $b64Warn
    "error" = $b64Error
}
 
<# ---------------------
            MAIN
   --------------------- #>

<#
    .SYNOPSIS
        Creates a notification bubble.
    .PARAMETER text
        Text of the notification.
    .PARAMETER title
        Title of the notification.
        Defaults to "Alert".
    .PARAMETER level
        Depending on the value, the notification bubble will have a different appearance.
        Defaults to "Info".
    .PARAMETER expiry
        Expiration time of the notification bubble in seconds.
        Defaults to 60.
    .PARAMETER filePath
        If specified, adds two buttons to the notification bubble ("Open file", "Open folder").
        These buttons allow the user to directly open the file as specified in the path or its corresponding root folder.
        Warning: Assumes a 'Get-ChildItem' object as its input.
#>
function Show-Notification {
    Param(
        [parameter(Mandatory = $true)]
            [string]$text,
        [string]$title = "Alert",
        [string]$level = "Info",
        [string]$bubbleTag = "Info",
        [int]$expiry = 60,
        $filePath
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText02)
    #[Windows.UI.Notifications.ToastTemplateType] | Get-Member -Static -Type Property

    # Transform b64 image to temp path
    $ImageFile = "$env:TEMP\$((new-guid).guid -replace '-', '')_ToastLogo.png"
    [byte[]]$Bytes = [convert]::FromBase64String($icons."$($level)")
    [System.IO.File]::WriteAllBytes($ImageFile,$Bytes)

    $RawXml = [xml] $Template.GetXml()
    ($rawxml.GetElementsByTagName("text") | ? id -eq "1").AppendChild($RawXml.CreateTextNode($Title)) > $null
    ($rawxml.GetElementsByTagName("text") | ? id -eq "2").AppendChild($RawXml.CreateTextNode($Text)) > $null
    ($rawxml.GetElementsByTagName("image") | ? id -eq "1").src = $imageFile

    if ($filePath) {
        # Convert path to # file:///
        $fileURI = $filePath.fullname -replace "\\", "/" -replace " ", "%20"
        $fileURI = "file:///" + $fileURI
        
        $dirURI = $filePath.directory[0].fullname -replace "\\", "/" -replace " ", "%20"
        $dirURI = "file:///" + $dirURI

        #https://docs.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/toast-schema#itoastactions
        $actions = $rawXML.CreateNode("element", "actions", "")
            $action = $rawXML.CreateNode("element", "action", "")
            $action.SetAttribute("activationType", "protocol")
            $action.SetAttribute("arguments", $fileURI)
            $action.SetAttribute("content", "Open file")
            
            $action2 = $rawXML.CreateNode("element", "action", "")
            $action2.SetAttribute("activationType", "protocol")
            $action2.SetAttribute("arguments", $dirURI)
            $action2.SetAttribute("content", "Open folder")

        $actions.AppendChild($action) | Out-Null
        $actions.AppendChild($action2) | Out-Null
        ($rawXML.toast).AppendChild($actions) | Out-Null
    }

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = $bubbleTag
    $Toast.Group = $bubbleTag
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddSeconds($expiry)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($bubbleTag)
    if (!($quiet)) {
        $Notifier.Show($Toast);
    }

    # Destroy image file
    Remove-Item $ImageFile -Force -ea SilentlyContinue
}
