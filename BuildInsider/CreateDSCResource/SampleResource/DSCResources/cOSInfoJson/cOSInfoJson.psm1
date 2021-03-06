# Enum for Ensure
Add-Type -TypeDefinition @"
    public enum EnsureType
    {
        Present,
        Absent
    }
"@ -ErrorAction SilentlyContinue

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]$Ensure,

        [parameter(Mandatory = $true)]
        [System.String]$Path
    )

    Write-Debug "Obtain Ensure status"
    $Ensure = if (!(Test-Path -Path $Path))
    {
        Write-Verbose "Path not exist."
        [EnsureType]::Absent.ToString()
    }
    else
    {
        Write-Debug "Read content and convert to JsonObject"
        $jsonObject = GetJsonObject -Path $Path

        Write-Debug "Check content is valid."
        if ((IsCIMClassValid -JsonObject $jsonObject) -and (IsCSNameValid -JsonObject $jsonObject))
        {
            Write-Debug "Content detected valid."
            [EnsureType]::Present.ToString()
        }
        else
        {
            Write-Debug "Content detected invalid."
            [EnsureType]::Absent.ToString()
        }
    }
    
    $returnValue = @{
        Ensure = [System.String]$Ensure
        Path = [System.String]$Path
    }
    return $returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([Void])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    #Ensure = "Absent"
    if ($Ensure -eq [EnsureType]::Absent.ToString())
    {
        if (Test-Path -Path $Path)
        {
            Write-Debug ("File found at '{0}'. Removing file." -f $Path)
            Remove-Item -Path $Path -Force > $null
            return;
        }
    }

    # Ensure = "Present"
    $json = Get-CimInstance -ClassName Win32_OperatingSystem | ConvertTo-Json
    $parent = Split-Path -Path $Path -Parent
    if (!(Test-Path -Path $parent))
    {
        New-Item -Path $parent -ItemType Directory -Force > $null
    }
    Write-Debug ("Output Win32_OperatingSystem information to Path '{0}'." -f $Path)
    Out-File -InputObject $json -FilePath $Path -Encoding utf8 -Force
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    [System.Boolean]$result = (Get-TargetResource -Ensure $Ensure -Path $Path).Ensure -eq $Ensure
    return $result
}

function GetJsonObject
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]$Path
    )

    $json = Get-Content -Path $Path -Encoding UTF8 -Raw | ConvertFrom-Json
    return $json
}

function IsCIMClassValid
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [PSCustomObject]$JsonObject
    )

    return $JsonObject.CimClass.CimSuperClassName -eq "CIM_OperatingSystem"
}

function IsCSNameValid
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [PSCustomObject]$JsonObject
    )

    return $JsonObject.CSName -eq [System.Net.DNS]::GetHostName()
}

Export-ModuleMember -Function *-TargetResource
