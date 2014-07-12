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
        $ModulePath = "$env:ProgramFiles\WindowsPowerShell\Modules",

        [Parameter(Mandatory=0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PullModulePath = "$env:ProgramFiles\WindowsPowerShell\DSCService\Modules"
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

    File DSCPullModuleFolder
    {
        SourcePath      = $OutFile
        DestinationPath = $PullModulePath
        Type            = "File"
        Ensure          = "Present"
    }

    Script ModuleCheckSum
    {
        SetScript       = {New-DSCCheckSum (Join-Path $using:PullModulePath (Split-Path $using:OutFile -Leaf))}
        TestScript      = {Test-Path "$(Join-Path $using:PullModulePath (Split-Path $using:OutFile -Leaf)).checksum"}
        GetScript       = {@{OutFile = "$((Join-Path $using:PullModulePath (Split-Path $using:OutFile -Leaf)).checksum)"}}
    }
} 

$param = @{
    DownloadPath    = "http://gallery.technet.microsoft.com/scriptcenter/xDscDiagnostics-PowerShell-abb6bcaa/file/116315/1/xDscDiagnostics-2.0.zip"
    OutFile         = "C:\Tools\xDscDiagnostics_2.0.zip"
    SourcePath      = "C:\Tools\xDscDiagnostics"
    OutPutPath      = "c:\xDscDiagnostics"
}

DownloadxDSCResource @param
Start-DscConfiguration -Wait -Verbose -Path $param.OutPutPath 