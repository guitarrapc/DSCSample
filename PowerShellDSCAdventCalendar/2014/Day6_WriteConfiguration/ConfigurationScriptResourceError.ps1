Script Disable6to4
{
    # can't use positional parameter
    SetScript  = {Set-Net6to4Configuration "Disabled"}
    TestScript = {(Get-Net6to4Configuration).State -eq "Disabled"}
    GetScript  = {return @{
            TestScript = $TestScript
            SetScript  = $SetScript
            GetScript  = $GetScript
            Result     = (Get-Net6to4Configuration).State -eq "Disabled"
        }
    }
}