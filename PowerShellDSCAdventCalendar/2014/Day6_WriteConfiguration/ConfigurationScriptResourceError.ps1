Script Disable6to4
{
    SetScript  = {Set-Net6to4Configuration -State "Disabled"}
    TestScript = {(Get-Net6to4Configuration).State -eq "Disabled"}
    GetScript  = {return @{
            TestScript = $TestScript
            SetScript  = $SetScript
            GetScript  = $GetScript
            Result     = (Get-Net6to4Configuration).State -eq "Disabled"
        }
    }
}