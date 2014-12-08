# コンフィグレーション (あるべき状態)
Configuration Service
{
    param
    (
        [Parameter(Mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Role = "web"
    )

    $service = $Allnodes.Where{$_.Role -eq $Role}.Service
    $state = "Running"
    $startupType = "Automatic"

    Node $Allnodes.Where{$_.Role -eq $Role}.NodeName
    {
        foreach ($x in $service)
        {
            Service $x
            {
                Name = $x
                State = $state
                StartupType = $startupType
            }
        }
    }
}

# コンフィグレーションデータ (環境データ)
$configuraionData = @{
    AllNodes = @(
        @{
            NodeName = '*'
        },
        @{
            NodeName = "127.0.0.1"
            Role     = "dsc"
            Service  = "WinRM", "Winmgmt"
        },
        @{
            NodeName = 'web.contoso.com'
            Role     = "web"
            Service  = "IISAdmin", "W3SVC"
        }
    )
}

Service -ConfigurationData $configuraionData -OutputPath service -Role dsc