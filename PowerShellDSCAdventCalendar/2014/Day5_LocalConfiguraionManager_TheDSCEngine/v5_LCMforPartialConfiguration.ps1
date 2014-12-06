[DSCLocalConfigurationManager()]
configuration v5PULLNodeLCMSetting
{
   Node localhost
   {
      Settings
      {
          RefreshMode = "Pull"
          ConfigurationID = 'a5f86baf-f17f-4778-8944-9cc99ec9f992'
          RebootNodeIfNeeded = $true
      }
 
      ConfigurationRepositoryWeb PullSvc1
      {
          serverURL = 'http://wmf5-1.sccloud.lab:8080/OSConfig/PSDSCPullServer.svc'
          AllowUnSecureConnection = $true
      }
 
      ConfigurationRepositoryWeb PullSvc2
      {
          ServerURL = 'http://wmf5-2.sccloud.lab:8080/SQLConfig/PSDSCPullServer.svc'
          AllowUnsecureConnection = $true
      }
 
      PartialConfiguration OSConfig
      {
         Description = 'Configuration for the Base OS'
         ConfigurationSource = '[ConfigurationRepositoryWeb]PullSvc1'
      }
 
      PartialConfiguration SQLConfig
      {
         Description = 'Configuration for the Web Server'
         ConfigurationSource = '[ConfigurationRepositoryWeb]PullSvc2'
         DependsOn = '[PartialConfiguration]OSConfig'
      }
   }
} 