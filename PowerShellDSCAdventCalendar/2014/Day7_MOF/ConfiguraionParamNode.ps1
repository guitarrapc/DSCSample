Configuration Service
{
    param
    (
        [Parameter(Mandatory = 1)]
        [string[]]$Node
    )

    $service = "WinRM", "winmgmt"
    $state = "Running"
    $startupType = "Automatic"

    Node $Node
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