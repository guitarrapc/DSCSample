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
                ServerUrl                    = "http://10.0.2.20:8080/PSDSCPullServer/PSDSCPullServer.svc"
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
    guid = cat c:\DSCSample\PowerShellSessionVol3\guid\guid.txt
    ConfigurationData = . "c:\DSCSample\PowerShellSessionVol3\Configuration\ConfigurationData\ConfigurationData.ps1"
    OutputPath = "C:\ChangeNodeToPull"
}
ChangeNodeToPull @param

# Apply
Set-DscLocalConfigurationManager -Path $outPath -Verbose 

# Check LCM
$CimSession = New-CimSession -ComputerName 10.0.2.11
Get-DscLocalConfigurationManager -CimSession $CimSession 
