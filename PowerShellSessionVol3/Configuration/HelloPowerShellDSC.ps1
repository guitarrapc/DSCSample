Configuration HelloPowerShellDSC
{
    Node $AllNodes.Where{$_.Role -eq "pull"}.NodeName
    {
        File HelloDSCFile
        {
            DestinationPath = "C:\HelloDSCFile.txt"
            Ensure = "Present"
            Type = "File"
            Contents = "Hello PowerShell DSC World!!"
        }
    }
} 

# Create mof
$param = @{
    ConfigurationData = c:\DSCSample\PowerShellSessionVol3\Configuration\ConfigurationData\ConfigurationData.ps1
    outputPath = "c:\HelloPowerShellDSCPull"
}
HelloPowerShellDSC @param

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
