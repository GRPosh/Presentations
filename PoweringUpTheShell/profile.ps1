#requires -Modules BetterCredentials

#region Aliases

$editors = @{
    micro = "${env:SystemDrive}\Chocolatey\bin\micro.bat"
    psedit = "${env:WinDir}\System32\WindowsPowerShell\v1.0\powershell_ise.exe"
    vsedit = "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
}


foreach ($editor in $editors.GetEnumerator()) {
    if (Test-Path -Path $editor.Value) {
        Set-Alias -Name $editor.Name -Value $editor.Value -ErrorAction SilentlyContinue |
            Out-Null
    } else {
        Write-Warning -Message "Could not set Alias for '$($editor.Name)'. Part of path '$($editor.Value)' could not be found."
    }
}

#endregion Aliases


#region PSDrives

$drives = @{
    GitHub = "${env:UserProfile}\Documents\GitHub"
    GitLab = "${env:UserProfile}\Documents\GitLab"
}

foreach ($drive in $drives.GetEnumerator()) {
    if ((Test-Path -Path $drive.Value) -and -not (Test-Path -Path $drive.Name)) {
        New-PSDrive -Name $drive.Name -Root $drive.Value -PSProvider FileSystem -ErrorAction SilentlyContinue |
            Out-Null
    } else {
        Write-Warning -Message "Could not create PSDrive '$($drive.Name)'.  Part of path '$($drive.Value)' could not be found."
    }
}

#endregion PSDrives


#region Variables

$scriptFunctionPath = "${home}\Documents\GitHub\PSFunctions\Functions"
if (Test-Path -Path $scriptFunctionPath) {
    if ($scriptFunctionPath -notin ($env:Path -split ";")) {
        [System.Environment]::SetEnvironmentVariable(
            "Path", ($env:Path += ";${scriptFunctionPath}"), [System.EnvironmentVariableTarget]::User
        )
    }
} else {
    Write-Warning -Message "PSFunctions repository not cloned to '$scriptFunctionPath'.  Clone 'https://github.com/dotps1/PSFunctions' to '$scriptFunctionPath'."
}

$PSGalleryApiKey = (Get-Credential -UserName PSGallery).GetNetworkCredential().Password

#endregion Variables
