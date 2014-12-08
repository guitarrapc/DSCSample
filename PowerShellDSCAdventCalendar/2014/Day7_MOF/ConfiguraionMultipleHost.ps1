Configuration Service
{
    $service = "WinRM", "Winmgmt"
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

Service -OutputPath service