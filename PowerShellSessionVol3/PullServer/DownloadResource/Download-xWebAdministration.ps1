Configuration DownloadxDSCResource
{
    param
    (
        [Parameter(Mandatory=1)]
        [String[]]
        $DownloadPath,

        [Parameter(Mandatory=1)]
        [String]
        $OutFile,

        [Parameter(Mandatory=1)]
        [String]
        $SourcePath,
 
        [Parameter(Mandatory=0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ModulePath = "$env:ProgramFiles\WindowsPowerShell\Modules"
    )
 
    File DownloadDirectory
    {
        DestinationPath = Split-Path $OutFile -Parent
        Type            = "Directory"
        Ensure          = "Present"
    }

    Script Download
    {
        SetScript       = {(New-Object System.Net.WebClient).DownloadFile("$using:DownloadPath", "$using:OutFile")}
        TestScript      = {Test-Path "$using:OutFile"}
        GetScript       = {@{OutFile = "$using:OutFile"}}
    }

    Archive Unzip
    {
        Path            = $OutFile
        Destination     = $SourcePath
    }

    File DSCResourceFolder
    {
        SourcePath      = $SourcePath
        DestinationPath = $ModulePath
        Recurse         = $true
        Type            = "Directory"
        Ensure          = "Present"
    }
} 

$param = @{
    DownloadPath    = "http://gallery.technet.microsoft.com/scriptcenter/xWebAdministration-Module-3c8bb6be/file/111374/1/xWebAdministration_1.2.zip"
    OutFile         = "C:\Tools\xWebAdministration_1.2.zip"
    SourcePath      = "C:\Tools\xWebAdministration"
    OutPutPath      = "c:\xWebAdministration"
}

DownloadxDSCResource @param
Start-DscConfiguration -Wait -Verbose -Path $param.OutPutPath 