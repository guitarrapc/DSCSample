# Configuraion sample

Configuration WebServer
{ 
    WindowsFeature IIS
    {
        Ensure               = "Present"
        Name                 = "Web-Server"
        IncludeAllSubFeature = $false
        LogPath               = "C:\Logs\DSC\WindowsFeature\Web-Server.txt"
    }
}

# MOF compiled from Configuration

instance of MSFT_RoleResource as $MSFT_RoleResource1ref
{
ResourceID = "[WindowsFeature]IIS::[WebServer]WebServer";
 LogPath = "C:\\Logs\\DSC\\WindowsFeature\\Web-Server.txt";
 IncludeAllSubFeature = False;
 Ensure = "Present";
 SourceInfo = "C:\\WebServer.ps1::3::5::WindowsFeature";
 Name = "Web-Server";
 ModuleName = "PSDesiredStateConfiguration";
 ModuleVersion = "1.0";

};