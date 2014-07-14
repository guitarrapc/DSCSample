DSCSample
=========

DSC Sample for Windows PowerShell


Prerequisites
=========

You may need to follow some rule to test this sample.
This is for your ease test.

1. Accessible with Server and Node by Http.
2. Pull Server and Node are same Password.
3. Enabled PSRemoting.
4. Execution Policy is "Remote Signed" or "ByPass"
5. Run with Windows Server 2012 R2. (not Windows Server 2012 + WMF 4.0)

PowerShellSessionVol3
=========

This session is for PowerShell users to introduce PowerShell DSC Pull mode.
There are several Demo to understand how DSC Pull is working.

# How to use

### git pull and edit node information

1. Create 2 instances. 1 is for DSC PULL Server, the other is Pull Node.
2. Clone repogitory into any path of Pull Server.
3. Edit ConfigurationData by run ```DSCSample\PowerShellSessionVol3\Edit-ConfigurationData.ps1``` as PowerShell. You may find IPAddress is assign to role, change it as you like.
4. After step complete, close ISE.
 
### Create Pull server
 
1. Open ISE and Run  ```DSCSample\PowerShellSessionVol3\PullServer\DownloadResource``` and it will install PSDSCPullServer into your host.
2. Open IE and try ```http://127.0.0.1:8080/PSDSCPullServer/PSDSCPullServer.svc```. If XML then installation is success. 
3. After step complete, close ISE.

### Create Pull Node

1. Open ISE and Run ```DSCSample\PowerShellSessionVol3\LCM\ChangeNodeToPull.ps1```. to change your node from PUSH to PULL.
2. If Get-DSCLocalConfigurationManager > RefreshMode show as Pull, LCM change is success.
3. After step complete, close ISE.
 
### try Configuration

1. Open ISE and Run ```DSCSample\PowerShellSessionVol3\Configuration\CombineWebServer.ps1```. This will immediately execute node to retrieve mof from PULL Server.
2. This script runs ```Get-DSCConfiguration```. If this shows as File is present, then configuration is success. 
3. After step complete, close ISE.

### try Nested Configuration

1. DSC Also allows you to nest your configuration. Open ISE and Run ```DSCSample\PowerShellSessionVol3\PullServer\DownloadResource\Download-xWebAdministration.ps1```. This download resource and set to module foler.
2. After step complete, close ISE.
3. Open ISE and Run ```DSCSample\PowerShellSessionVol3\Configuration\CombineWebServer.ps1```.
4. If node Firewall is open, then ```http://NODEIP:7070/``` will show you iisstart.htm 

### DIagnostics

1. If you use ```DSCSample\PowerShellSessionVol3\PullServer\DownloadResource\Download-xDscDiagnostics.ps1``` then you can Diagnostic DSC operations.
2. install module inside PULL Server and Node. Run ```DSCSample\PowerShellSessionVol3\Configuration\CheckDSCoperations.ps1```. Valentia will help you invoke without thinking Credential.

That's all. Try DSC Pull and have a fun!

# DSC functionality Detail for Beginner
----------

## LCM

You may understand what LCM is doing. This is base understanding of DSC and must understand at first.

1. What DSC Local Configuration Manager works with DSC Pull.
2. Each parameters you can congfigure in LCM for PULL.
3. Get current LCM Configuration.
4. Set LCM Configuration to PULL.

## Resources

Resource is the thing that indicate what DSC Configuration can do.

Resource will allow code hint for PowerShell to write Configuration and also create mof which apply to node.

If you want to do anything with Resources, you may need to get/write resource. I will not explain how to write resouce in this section.

1. How to download resource.
2. Where to set resource.
3. How to allow node to donwload resource.

## Create Pull Server

You can create pull server in 3 sec. Wow! great DSC is.

1. Write Configuration for Pull Server.
2. Apply configuration for DSC PULL Server creation.

## Node Configuration

Now the time you can write configuration!

Configuration is not different with PUSH or PULL, just write it as you want:)

1. Simple configuration to create File content.
2. Simple configuration to pass node inforamtaion with ConfigurationData.
3. How to nest configuration in 1 source.
4. How to nest configuration with separate configuration file.

## mof

The main difference with PUSH and PULL is how node reach to mof.

With PULL Mode, Node should recognise "which mof is mine?". You may need to find mof for THE NODE.

1. Where to set mof for Pull?
2. How to match mof with node?
3. How to detect change in mof?

## Apply

Last point is apply. Apply will be run from NODE, not DSC Pull Server.

1. How to controll apply duration.
2. How to apply immediately.
3. How to trace DSC operation log.
4. How to check "Which server was when applied"?
5. How to change configuration to be applied.

That's set. Let's dive into DSC Pull world. 