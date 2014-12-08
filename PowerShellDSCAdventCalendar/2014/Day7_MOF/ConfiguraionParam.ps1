Configuration Service
{
    param
    (
        [string[]]$Service
    )
    $state = "Running"
    $startupType = "Automatic"

    Node ("127.0.0.1", "192.168.1.1")
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

Service -Service WinRm, Winmgmt