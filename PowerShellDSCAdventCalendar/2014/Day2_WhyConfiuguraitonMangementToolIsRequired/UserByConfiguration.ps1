configuration UserAndGroup
{
    param
    (
        [parameter(Mandatory = 1)]
        [PSCredential[]]$credential,
        
        [parameter(Mandatory = 0)]
        [string]$Group = "Administrators"
    )
 
    foreach ($x in $credential)
    {
        User $x.UserName
        {
            UserName = $x.UserName
            Ensure = "Present"
            Password = $x
            PasswordNeverExpires = $true
            PasswordChangeNotAllowed = $true
        }
 
        Group $x.UserName
        {
            GroupName = $Group
            Ensure = "Present"
            MembersToInclude = $x.UserName
            DependsOn = "[User]{0}" -f $x.UserName
        }
    }
}
 
$path = "d:\UserAndGroup"
UserAndGroup -OutputPath $path -credential (Get-Credential)
Start-DscConfiguration -Wait -Force -Verbose -Path $path