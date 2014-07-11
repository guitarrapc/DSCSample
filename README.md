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