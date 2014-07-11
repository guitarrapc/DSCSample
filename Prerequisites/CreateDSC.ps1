function Main
{
    $vpcId = Get-AWSModuleVPCIdFromName -TagName "Production"
    [ipaddress[]]$ipaddress = target '10.0.2.20', '10.0.2.11'

    ## -- Create EC2 Instance
    $ec2Param = @{
        EC2AMIImageName         = "Windows_Server-2012-R2_RTM-Japanese-64Bit-Base-2014.05.20"
        EC2InstanceType         = 'c3.2xlarge'
        keyName                 = 'dsc'
        AvailabilityZone        = 'ap-northeast-1c'
        vpcId                   = $vpcId
        VPCSecurityGroupTagName = 'dsc-sample'
        InstanceProfileName     = 'dsc'
        SubNetState             = 'Available'
        IpAddress               = $ipaddress
        userdata                = Get-AWSModuleUserData -userdataServerType web -userdataUsageType scaling -project white -userdataStartType spot
        AssociatePublicIp       = $true
        SpotInstanceType        = "persistent"
        SpotPrice               = "0.45"
    }
    $spotInstanceRequest = Request-AWSModuleEC2SpotInstance @ec2Param -Verbose

    ## -- Sleep until instance creation start
    sleep -second 10
    Watch-AWSModuleEC2SpotInstanceRequestStatus -SpotInstanceRequestId $spotInstanceRequest.SpotInstanceRequestId -desiredState active | ft

    ## -- Tagging to created instance
    $tagParam = @{
        vpcId     = $vpcId
        Name      = 'dsc-test2012R2-'
        Stack     = 'test'
        Role      = 'dsc'
        ipaddress = $ipaddress
    }
    New-AWSModuleEC2TagAsign @tagParam -TagNameWithIP

    # monitor ec2 status
    $instanceId = (Get-EC2SpotInstanceRequest -SpotInstanceRequestIds $spotInstanceRequest.SpotInstanceRequestId).InstanceId
    Watch-AWSModuleEC2Status -InstanceId $instanceId -desiredState Running -reachability Passed | ft
}


Main