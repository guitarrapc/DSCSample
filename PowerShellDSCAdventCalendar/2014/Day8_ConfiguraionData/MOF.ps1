/*
@TargetNode='127.0.0.1'
@GeneratedBy=acquire
@GenerationDate=12/08/2014 02:59:25
@GenerationHost=WINDOWS81X64
*/
 
instance of MSFT_ServiceResource as $MSFT_ServiceResource1ref
{
ResourceID = "[Service]WinRM";
 State = "Running";
 SourceInfo = "::19::13::Service";
 Name = "WinRM";
 StartupType = "Automatic";
 ModuleName = "PSDesiredStateConfiguration";
 ModuleVersion = "1.0";
 
 ConfigurationName = "Service";
 
};
instance of MSFT_ServiceResource as $MSFT_ServiceResource2ref
{
ResourceID = "[Service]Winmgmt";
 State = "Running";
 SourceInfo = "::19::13::Service";
 Name = "Winmgmt";
 StartupType = "Automatic";
 ModuleName = "PSDesiredStateConfiguration";
 ModuleVersion = "1.0";
 
 ConfigurationName = "Service";
 
};
instance of OMI_ConfigurationDocument
{
 Version="1.0.0";
 Author="acquire";
 GenerationDate="12/08/2014 02:59:25";
 GenerationHost="WINDOWS81X64";
 Name="Service";
};