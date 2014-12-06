Configuration LCM
{
    Node 10.0.0.10
    {
        LocalConfigurationManager 
        {
            RebootNodeIfNeeded = $true
        }
    }
}

LCM -OutputPath LCM
Set-DscLocalConfigurationManager -Path LCM -Credential (Get-Credential) -ComputerName 10.0.0.10