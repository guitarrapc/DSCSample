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