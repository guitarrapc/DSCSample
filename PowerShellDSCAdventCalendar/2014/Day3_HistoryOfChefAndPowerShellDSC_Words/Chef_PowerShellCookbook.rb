# Do you think is work? NO........
powershell_script "executionpolicy" do
    code 'Set-ExecutionPolicy RemoteSigned'
    not_if "(Get-ExecutionPolicy -Scope LocalMachine) -eq 'RemoteSiggned'"
end

powershell_script "smbsharelogs" do
    code 'New-SMBShare logshare C:\logs'
    not_if 'Get-SMBShare logshare'
end



# To work with x64..... awful

powershell_script "executionpolicy" do
    code 'Set-ExecutionPolicy RemoteSigned'
    not_if "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noprofile -executionpolicy bypass -command ((Get-ExecutionPolicy -Scope LocalMachine) -eq 'RemoteSiggned')"
end

powershell_script "smbsharelogs" do
    code 'New-SMBShare logshare C:\logs'
    not_if "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noprofile -executionpolicy bypass -command (Get-SMBShare logshare)"
end



# using guard Interpreter to make it in x64

powershell_script "executionpolicy" do
    guitad_interpreter :powershell_script
    code 'Set-ExecutionPolicy RemoteSigned'
    not_if "(Get-ExecutionPolicy -Scope LocalMachine) -eq 'RemoteSiggned'"
end

powershell_script "smbsharelogs" do
    guitad_interpreter :powershell_script
    code 'New-SMBShare logshare C:\logs'
    not_if 'Get-SMBShare logshare'
end
