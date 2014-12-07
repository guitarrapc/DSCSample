Configuration Service
{
    Service WinRM
    {
        Name = "WinRM"
        State = "Running"
        StartupType = "Automatic"
    }

    Service Winmgmt
    {
        Name = "Winmgmt"
        State = "Running"
        StartupType = "Automatic"
    }
}