# -- You must copy xDSCDiagnostic to Node Module Path -- #

# Show DSC log
Get-xDscOperation -Newest 1 -ComputerName $nodename
# you can use valentia https://github.com/guitarrapc/valentia for asynchronous invokation
#valea $nodename {(Get-xDscOperation -Newest 1).AllEvents}

# Trace DSC Log
Trace-xDscOperation -seq 1 -ComputerName $nodename
# you can use valentia https://github.com/guitarrapc/valentia for asynchronous invokation
# valea $nodename {Trace-xDscOperation -seq 1}