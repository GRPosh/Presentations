configuration New-MyFirstConfiguration
{
    param([string[]]$Nodes)
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node $Nodes
    {
        # Call Resource Provider
        # E.g: WindowsFeature, File
        File Telnet
        {
           Ensure = "Present"
           Type = "Directory"
           DestinationPath = "C:\My"
        }
      
    }
}

New-MyFirstConfiguration -Nodes "localhost"
Start-DscConfiguration -Path .\New-MyFirstConfiguration -Wait -Verbose -Force