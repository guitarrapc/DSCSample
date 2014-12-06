Configuration LCM
{
    Node localhost
    {
        LocalConfigurationManager 
        {
            RebootNodeIfNeeded = $true
        }
    }
}

LCM -OutputPath LCM
Set-DscLocalConfigurationManager -Path LCM