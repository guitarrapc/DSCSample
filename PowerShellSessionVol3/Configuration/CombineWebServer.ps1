Configuration WebServer
{
    WindowsFeature IIS
    {
        Ensure               = "Present"
        Name                 = "Web-Server"
        IncludeAllSubFeature = $true
    }
  
    WindowsFeature IISMgmt
    {
        Ensure               = "Present"
        Name                 = "Web-Mgmt-Tools"
        IncludeAllSubFeature = $true
    }

    WindowsFeature ASP
    {
        Ensure               = "Present"
        Name                 = "Web-Asp-Net45"
    }
}

Configuration SiteDirectory
{
    File DirectoryWebSite
    {
        Ensure               = "Present"
        DestinationPath      = "C:\inetpub\Sample"
        Type                 = "Directory"
    }
}

Configuration WebAppPool
{
    Import-DscResource -ModuleName xWebAdministration
    xWebAppPool WebAppPool
    {
        Ensure               = "Present"
        Name                 = "Sample"
        State                = "Started"
    }
}

Configuration WebSite
{
    param
    (
        [string]$name
    )
    Import-DscResource -ModuleName xWebAdministration
    xWebSite WebSiteDSCServer
    {
        Ensure               = "Present"
        Name                 = $name
        State                = "Started"
        BindingInfo          = MSFT_xWebBindingInformation `
                                    {
                                        Protocol              = "HTTP"
                                        Port                  = 7070 
                                    }
        PhysicalPath         = "C:\inetpub\Sample"
        ApplicationPool      = "Sample"
    }
}

configuration Copywwwroot
{
    File CopywwwRoot
    {
        Ensure          = "Present"
        DestinationPath = "C:\inetpub\Sample\iisstart.htm"
        Type            = "File"
        SourcePath      = "C:\inetpub\wwwroot\iisstart.htm"
    }
}

Configuration CombineWebServer
{
    Node $AllNodes.Where{$_.Role -eq "pull"}.NodeName
    {
        WebServer     IISASP {}
        SiteDirectory SiteDirectory {}
        WebAppPool    AppPool {}
        WebSite       WebSite {
            name = "Sample"}
        Copywwwroot   Copywwwroot {}
    }
}

$param = @{
    ConfigurationData = c:\DSCSample\PowerShellSessionVol3\Configuration\ConfigurationData\ConfigurationData.ps1
    outputPath = "C:\CombineWebServer"
}
CombineWebServer @param

# Configuraionを実行して生成された.mofファイルのパスをコピー元とする
$nodename = $param.ConfigurationData.AllNodes.Where{$_.Role -eq "pull"}.NodeName
$source = Join-Path -Path $param.outputPath -ChildPath "$nodename.mof" -Resolve

# PullノードのLCMで、ConfigurarionIDに指定したguid
$guid = cat c:\DSCSample\PowerShellSessionVol3\guid\guid.txt

# PushノードのLCMに指定したguidでmofファイル名を指定し、PSDSCPullServerのConfiguraionPathに指定したパスをコピー先とする
$dest   = "C:\Program Files\WindowsPowerShell\DscService\Configuration\$guid.mof"

# Configuraionを実行して生成された .mofファイルをコピーする
Copy-Item -Path $source -Destination $dest

# コピーした .mofファイルのchecksumファイルを生成する。
New-DSCCheckSum $dest -Verbose -Force



# Show current LCM Status
$cimSession = New-CimSession -ComputerName $nodename
Get-DscLocalConfigurationManager -CimSession $cimSession

# Run Immediately
valea $nodename {Invoke-CimMethod -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Cl MSFT_DSCLocalConfigurationManager -Method PerformRequiredConfigurationChecks -Arguments @{Flags = [System.UInt32]1}}

# Show current Configuration
Get-DscConfiguration -CimSession $cimSession

# You must copy xDSCDiagnostic to Node Module Path
# Show DSC log
valea $nodename {(Get-xDscOperation -Newest 1).AllEvents}

# Trace DSC Log
valea $nodename {Trace-xDscOperation -seq 1}