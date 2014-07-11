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
    DownloadPath    = "http://gallery.technet.microsoft.com/scriptcenter/xDscDiagnostics-PowerShell-abb6bcaa/file/116315/1/xDscDiagnostics-2.0.zip"
    OutFile         = "C:\Tools\xDscDiagnostics-2.0.zip"
    SourcePath      = "C:\Tools\xDscDiagnostics"
    OutPutPath      = "c:\xDscDiagnostics"
}

DownloadxDSCResource @param
Start-DscConfiguration -Wait -Verbose -Path $param.OutPutPath 