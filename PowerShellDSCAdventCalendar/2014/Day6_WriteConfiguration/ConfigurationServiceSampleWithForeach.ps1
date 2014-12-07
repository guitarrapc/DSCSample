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