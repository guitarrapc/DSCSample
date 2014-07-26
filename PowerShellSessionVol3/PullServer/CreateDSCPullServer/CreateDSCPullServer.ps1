Configuration DSCPullServer
{
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node $AllNodes.Where{$_.Role -eq "DSCServer"}.NodeName
    {
        WindowsFeature DSCService
        {
            Name   = "DSC-Service"
            Ensure = "Present"
        }

        WindowsFeature IIS
        {
            Name                  = "Web-Server"
            Ensure                = "Present"
        }

        WindowsFeature IISSecurity
        {
            Name    = "Web-Security"
            Ensure  = "Present"
            LogPath = "C:\Logs\DSC\WindowsFeature\Web-Security.txt"
            IncludeAllSubFeature = $true
        }

        WindowsFeature IISMgmt
        {
            Name                  = "Web-Mgmt-Tools"
            Ensure                = "Present"
        }

        WindowsFeature ASPNET
        {
            Name                  = "Web-Asp-Net45"
            Ensure                = "Present"
            IncludeAllSubFeature  = $true
        }

        xDSCWebService DSCPullServer
        {
            EndpointName          = "PSDSCPullServer"
            Ensure                = "Present"
            IsComplianceServer    = $false
            CertificateThumbPrint = "AllowUnencryptedTraffic"
            Port                  = 8080
            State                 = "Started"
            PhysicalPath          = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            ConfigurationPath     = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            ModulePath            = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            DependsOn             = "[WindowsFeature]DSCService"
        }

        xDSCWebService DSCComplianceServer
        {
            EndpointName          = "PSDSCComplianceServer"
            Ensure                = "Present"
            IsComplianceServer    = $true
            CertificateThumbPrint = "AllowUnencryptedTraffic"
            Port                  = 8081
            State                 = "Started"
            PhysicalPath          = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
            DependsOn             = ("[WindowsFeature]DSCService", "[xDSCWebService]DSCPullServer")
        }
    }
}


$ConfigurationData = . "c:\DSCSample\PowerShellSessionVol3\Configuration\ConfigurationData\ConfigurationData.ps1"
$outputPath = "C:\DSCPullServer"
DSCPullServer -OutputPath $outputPath -ConfigurationData $ConfigurationData
Start-DscConfiguration -Path $outputPath -Wait -Verbose  