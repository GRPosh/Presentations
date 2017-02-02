Install-Module cChoco

configuration New-MySecondConfiguration
{
    param([string[]]$Nodes)

    Import-DscResource -Module cChoco

    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node $Nodes
    {
        # Call Resource Provider
        # E.g: WindowsFeature, File
        cChocoPackageInstaller Chrome
        {
           Ensure = "present"
           Name = "googlechrome"
        }
      
    }
}

New-MySecondConfiguration -Nodes "localhost"
Start-DscConfiguration -Path .\New-MySecondConfiguration -Wait -Verbose -Force