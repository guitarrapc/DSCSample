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
$cim = New-CimSession -Credential (Get-Credential) -ComputerName 10.0.0.10
Set-DscLocalConfigurationManager -Path LCM -CimSession $cim