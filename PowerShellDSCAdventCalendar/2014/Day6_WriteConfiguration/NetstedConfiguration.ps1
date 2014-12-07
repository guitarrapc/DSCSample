Configuration Service
{
    $service = "WinRM", "Winmgmt"
    $state = "Running"
    $startupType = "Automatic"

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

Configuration Remote
{
    param
    (
        [Parameter(Mandatory = 1, Position = 0)]
        [pscredential]$Credential
    )

    User Remote
    {
        UserName = $Credential.UserName
        Ensure = "Present"
        Password = $Credential
        Disabled = $false
        PasswordNeverExpires = $true
    }

    Group Remote
    {
        GroupName = "RemoteUser"
        Ensure = "Present"
        MembersToInclude = $Credential.UserName, "Administrators"
        DependsOn = "[User]Remote"
    }
}

Configuraion NetstedConfiguration
{
    param
    (
        [Parameter(Mandatory = 1, Position = 0)]
        [string]$Node,

        [Parameter(Mandatory = 1, Position = 1)]
        [pscredential]$Credential
    )
    
    Node $Node
    {
        Service {}
        Remote {
            Credential = $Credential
        }
    }
}

