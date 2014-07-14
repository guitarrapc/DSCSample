Configuration ChangeNodeToPull
{
    param
    (
        [string]
        $guid
    )

    # Node 10.0.2.11 と同義
    Node $AllNodes.Where{$_.Role -eq "pull"}.NodeName
    {
        LocalConfigurationManager
        {
            AllowModuleOverwrite           = $true
            ConfigurationID                = $guid
            ConfigurationMode              = "ApplyAndAutoCorrect"
            DownloadManagerName            = "WebDownloadManager"
            DownloadManagerCustomData      = @{
                ServerUrl                    = "http://{0}:8080/PSDSCPullServer/PSDSCPullServer.svc" -f ($AllNodes.Where{$_.Role -eq "DSCServer"}.NodeName)
                AllowUnsecureConnection      = "true"}
            RefreshMode                    = "Pull"
            RebootNodeIfNeeded             = $true
            RefreshFrequencyMins           = 15
            ConfigurationModeFrequencyMins = 30
        }
    }
} 


# Create mof
$param = @{
    guid = cat ..\guid\guid.txt
    ConfigurationData = . "..\Configuration\ConfigurationData\ConfigurationData.ps1"
    OutputPath = "C:\ChangeNodeToPull"
}
ChangeNodeToPull @param

# Apply
Set-DscLocalConfigurationManager -Path $param.outputPath -Verbose 

# Check LCM
$CimSession = New-CimSession -ComputerName $param.ConfigurationData.AllNodes.Where{$_.Role -eq "pull"}.NodeName
Get-DscLocalConfigurationManager -CimSession $CimSession 
