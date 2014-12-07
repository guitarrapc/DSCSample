# read nested child configuration
Get-ChildItem -Path ChildConfiguration -File | %{ .$_.FullName }

# parent netsted configuraion
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

