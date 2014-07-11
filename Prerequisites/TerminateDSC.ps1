$spot = Get-EC2SpotInstanceRequest
$ec2 = Get-AWSModuleInstanceFromIPAddress -IPAddress '10.0.2.11', '10.0.2.20'
$terminate = $spot | where Instanceid -in $ec2.instanceid

Stop-EC2SpotInstanceRequest -SpotInstanceRequestIds $terminate.SpotInstanceRequestId
Stop-EC2Instance -Instance $terminate.InstanceId -Terminate
