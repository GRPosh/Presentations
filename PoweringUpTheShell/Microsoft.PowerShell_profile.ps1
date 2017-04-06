#requires -module PowerLine, PSGit
using module PowerLine

$PowerLinePrompt = 1,
    (
        $null, # No left-aligned content on this line
        @(
            @{ BackGround = "Gray"; ForeGround = "Black"; Text = { Get-Date -f "T" } }
        ),
        @(  
            @{ BackGround = "DarkCyan"; ForeGround = "White"; Text = { $MyInvocation.HistoryId } }
            @{ BackGround = "DarkBlue"; ForeGround = "White"; Text = { $pwd } }
            @{ Text = { Write-GitStatusPowerLine } }
        )
    )

Set-PowerLinePrompt -PowerLineFont

Set-GitPromptSettings -BranchBackground DarkCyan
