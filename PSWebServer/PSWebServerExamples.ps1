#PSWebServer - gist: https://gist.github.com/Tiberriver256/868226421866ccebd2310f1073dd1a1e

#Example 1
#---------------------
New-PSWebServer


#Example 2
#---------------------
New-PSWebServer -Public


#Example 3
#---------------------
New-PSWebServer -url http://localhost:8000/ -webschema @(
    Add-GetHandler -Path '/' -Script { "Welcome to PSWebServer!" }
    Get '/process'       { get-process |select name, id, path | ConvertTo-Json }
    Get '/prettyprocess' { Get-Process |ConvertTo-HTML name, id, path }
 )


#Example 4
#--------------------- 
New-PSWebServer -url http://localhost:8000/ -webschema @(
    Get '/' 
    Post '/startprocessbypost' {
       $processname = $Body.NotePad
       Start-Process $processname -PassThru | ConvertTo-HTML
    } 
    DELETE '/startprocessbyparameter/{FirstName}/{LastName}' { "First Name: $($Parameters.FirstName)  Last Name: $($Parameters.LastName)" }
 )
 
Invoke-RestMethod -Uri http://localhost:8000/startprocessbyparameter/Bob/Dylan
Invoke-RestMethod -Uri http://localhost:8000/startprocessbypost -Method Post -Body @{NotePad ="Notepad"}


#Example 5 - Use ShowMeNames.HTML to send data from a form to this URL
#--------------------- 
New-PSWebServer -url http://localhost:8000/ -webschema @(
    Post '/ShowMeNames' {
       $Body | ConvertTo-Html | Out-String
    }
 )


#Example 6
#---------------------
New-PSWebServer -url 'http://localhost:8080/' -webschema @(
    Post '/startprocessbypost' {
       $processname = $Body.ProcessName
       Start-Process $processname
    } @("Administrators")
    Get '/Process' { Get-Process } @("Users","Administrators")
 ) -AuthenticationScheme "Negotiate"


#Example 7
#---------------------
New-PSWebServer -url "http://$($env:COMPUTERNAME):8001/" -webschema @(
    Get '/MoveOU/{ComputerName}/' {
            "Moving $($parameters.ComputerName) from $($ADComputer.DistinguishedName) to 'OU=Clients,DC=MyDomain,DC=com'" >> D:\MDTConfiguration\MoveOU.log
            $ADComputer | Move-ADObject -TargetPath  "OU=Clients,DC=MyDomain,DC=com"
        }
) -Public


<#

    Some ideas for the future

    1. HTTPS Support
    2. Extensibility / Plug-in Support system
    3. Better debugging / development experience
    4. Impersonation

#>