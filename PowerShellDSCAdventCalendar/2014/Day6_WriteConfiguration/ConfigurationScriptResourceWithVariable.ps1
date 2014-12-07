Script Disable6to4
{
    $state = "Disabled"
    SetScript  = {Set-Net6to4Configuration -State "$using:state"}
    TestScript = {(Get-Net6to4Configuration).State -eq "$using:state"}
    GetScript  = {return @{
            TestScript = $TestScript
            SetScript  = $SetScript
            GetScript  = $GetScript
            Result     = (Get-Net6to4Configuration).State -eq "$using:state"
        }
    }
}