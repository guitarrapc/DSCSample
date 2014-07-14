function Edit-ConfigurationData([string]$path)
{
    PowerShell_ise.exe -File $path
}

$path = "Configuration\ConfigurationData\ConfigurationData.ps1"
Edit-ConfigurationData -path $path