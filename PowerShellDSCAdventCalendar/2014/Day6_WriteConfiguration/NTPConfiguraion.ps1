configuration ConfigureNTP
{
    param
    (
        # Primary は、 Client modeで定期同期 + SpecialPollIntervalを利用すること
        [parameter(Mandatory = 0, Position = 0)]
        [string]$NTPServer = "ntp.nict.jp",
        
        # Secondary は定期同期なし + fallback専用
        [parameter(Mandatory = 0, Position = 1)]
        [validateLength(1, 10)]
        [string[]]$FailOverNTPServer = ("s2csntp.miz.nao.ac.jp", "ntp.jst.mfeed.ad.jp")
    )

    $ntpServerValue1 = [string]($ntpServer | %{$_, (",0x{0:x}" -f "8")}) -replace " ,",","
    $ntpServerValue2 = [string]($FailOverNTPServers | %{$_, (",0x{0:x}" -f "a")}) -replace " ,",","
    $ntpServerValue = $ntpServerValue1, $ntpServerValue2 -join " "

    $ntpservers = @()
    $ntpservers += $ntpServer
    $ntpservers += $FailOverNTPServers | %{$_}

    $timeRootPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\W32Time"
    $NTPListPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers"

    Service w32time
    {
        Name = "W32Time"
        State = "Running"
        StartupType = "Automatic"
    }

    Script TimeZone
    {
        SetScript  = {tzutil /s "Tokyo Standard Time"}
        TestScript = {(Get-ItemProperty "registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").TimeZoneKeyName -eq "Tokyo Standard Time"}
        GetScript  = {return @{
                TestScript = $TestScript
                SetScript  = $SetScript
                GetScript  = $GetScript
                Result     = (Get-ItemProperty "registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").TimeZoneKeyName -eq "Tokyo Standard Time"
            }
        }
    }

    Registry NTPType
    {
        Key = "$timeRootPath\Parameters"
        ValueName = "Type"
        ValueType = "String"
        ValueData = "NTP"
        Ensure = "Present"
    }
   
    Registry NTPServer
    {
        Key = "$timeRootPath\Parameters"
        ValueName = "NTPServer"
        ValueType = "String"
        ValueData = $ntpServerValue
        Ensure = "Present"
    }

    Registry AnnounceFlags
    {
        Key = "$timeRootPath\Config"
        ValueName = "AnnounceFlags"
        ValueType = "DWord"
        ValueData = "5"
        Ensure = "Present"
    }

    # 最大何秒遅らせることを許容するか(これ以上大きな数値の修正が必要と判断された場合修正しない)
    Registry MaxPosPhaseCorrection
    {
        Key = "$timeRootPath\Config"
        ValueName = "MaxPosPhaseCorrection"
        ValueType = "DWord"
        ValueData = "1800"
        Ensure = "Present"
    }

    # 最大何秒遅らせることを許容するか(これ以上大きな数値の修正が必要と判断された場合修正しない)
    Registry MaxNegPhaseCorrection
    {
        Key = "$timeRootPath\Config"
        ValueName = "MaxNegPhaseCorrection"
        ValueType = "DWord"
        ValueData = "1800"
        Ensure = "Present"
    }

    # NTP Serverが 0x9の場合利用されない : 2^6  =   64 sec ( 1min)
    Registry MinPollInterval
    {
        Key = "$timeRootPath\Config"
        ValueName = "MinPollInterval"
        ValueType = "DWord"
        ValueData = "6"
        Ensure = "Present"
    }

    # NTP Serverが 0x9の場合利用されない : 2^10 = 1024 sec (17min)
    Registry MaxPollInterval
    {
        Key = "$timeRootPath\Config"
        ValueName = "MaxPollInterval"
        ValueType = "DWord"
        ValueData = "10"
        Ensure = "Present"
    }

    # Clock ゆらぎ 0 (Linuxはゆらぎを許容しないので 0必須)
    Registry LocalClockDispersion
    {
        Key = "$timeRootPath\Config"
        ValueName = "LocalClockDispersion"
        ValueType = "DWord"
        ValueData = "0"
        Ensure = "Present"
    }

    # w32time Debug log Event ID 37,33 (0＝記録しない、1＝不連続で修正された秒数を記録、2＝NTPサーバからの時刻データ受信を記録、3＝両方のログを記録)
    Registry ConfigEventLogFlags
    {
        Key = "$timeRootPath\Config"
        ValueName = "EventLogFlags"
        ValueType = "DWord"
        ValueData = "3"
        Ensure = "Present"
    }

    # w32time Debug log Event ID 37,33 (0＝記録しない、1＝不連続で修正された秒数を記録、2＝NTPサーバからの時刻データ受信を記録、3＝両方のログを記録)
    Registry NTPServerEnabled
    {
        Key = "$timeRootPath\TimeProviders\NtpServer"
        ValueName = "Enabled"
        ValueType = "DWord"
        ValueData = "1"
        Ensure = "Present"
    }

    # NTP Serverが 0x9の場合にmax/min Intervalの代わりに利用 : 900 sec (15min)
    Registry SpecialPollInterval
    {
        Key = "$timeRootPath\TimeProviders\NtpClient"
        ValueName = "SpecialPollInterval"
        ValueType = "DWord"
        ValueData = "900"
        Ensure = "Present"
    }

    # w32time Debug log Event ID 35,51 (0＝記録しない、1＝不連続で修正された秒数を記録、2＝NTPサーバからの時刻データ受信を記録、3＝両方のログを記録)
    Registry NTPClientEventLogFlags
    {
        Key = "$timeRootPath\TimeProviders\NtpClient"
        ValueName = "EventLogFlags"
        ValueType = "DWord"
        ValueData = "3"
        Ensure = "Present"
    }

    # NTP Server to select as default
    Registry DefaultNTPServer
    {
        Key = "$NTPListPath"
        ValueName = "(default)"
        ValueType = "String"
        ValueData = "1"
        Ensure = "Present"
    }

    # Set NTP Server list
    for ($i = 0, $i -lt $ntpservers.Count; $i++)
    {
        $valueName = $i + 1
        # NTP Server List
        Registry NTPServerList1
        {
            Key = "$NTPListPath"
            ValueName = $valueName
            ValueType = "String"
            ValueData = $ntpservers[$i]
            Ensure = "Present"
        }
    }
}