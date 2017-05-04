$WebSchema = @()
$WebSchema += Add-GetHandler -Path '/' -Script {
@"
    <!doctype html>
    <html>
        <head>
            <script src="https://cdn.jsdelivr.net/jquery/3.2.1/jquery.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.2.0/js/jquery.terminal.min.js"></script>
            <script src="https://cdn.jsdelivr.net/mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/jquery.terminal/1.2.0/css/jquery.terminal.min.css" rel="stylesheet"/>
            <style type="text/css">
                html, body {
                    height: 100%;
                    margin: 0;
                }

                #term_demo {
                    min-height: 100%; 
                }
            </style>
        </head>
        <body>
            <div id="term_demo"></div>
            <script>
                jQuery(function(`$, undefined) {
                    `$('#term_demo').terminal(function(command, term) {
                        if(command == 'cls') {
                            term.clear();
                        } else {
                            return $.post('command', {command: command})
                                .fail(function(xhr,status,error){
                                    term.error(xhr.responseText);
                                    term.resume();
                                });
                        }
                    }, {
                        greetings: 'PowerShell - WebShell',
                        name: 'ps_demo',
                        prompt: function(callback) {
                            var Response = $.ajax({
                                type: "POST",
                                url: "Prompt",
                                async: false
                            }).responseText;

                            callback(Response);
                        }
                    });
                });
            </script>
        </body>
    </html>
"@
}
$WebSchema += Add-PostHandler -Path '/Command' -Script {
    $null = New-Event -SourceIdentifier ConsoleMessageEvents -MessageData ($Body)
    $null = New-Event -SourceIdentifier ConsoleMessageEvents -MessageData ($Request | ConvertTo-Json | Out-String)
    $Result = & ([scriptblock]::Create($Body.command))
    $Result | Out-String
}
$WebSchema += Add-PostHandler -Path '/Prompt' -Script {
    prompt
}

New-PSWebServer -url "http://localhost:8080/" -webschema $WebSchema
#New-PSWebServer -url "http://+:8080/" -webschema $WebSchema -Public