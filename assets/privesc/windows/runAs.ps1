# Execute
# powershell -ExecutionPolicy Bypass -File c:\windows\temp\runAs.ps1

$secpasswd = ConvertTo-SecureString "Passw0rd!" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("Administrator",
$secpasswd)
$computer = "WKSTN-05"
[System.Diagnostics.Process]::Start("C:\Windows\temp\benign.exe","", $mycreds.Username, $mycreds.Password, $computer)
