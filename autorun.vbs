Set WshShell = CreateObject("WScript.Shell")
Set FileSystemObject = CreateObject("Scripting.FileSystemObject")

' Se obtiene la ruta del directorio temporal del sistema
tempPath = WshShell.ExpandEnvironmentStrings("%TEMP%")

' Se construye la ruta completa al script PowerShell
ps1Path = tempPath & "\data_SP\script.ps1"

WshShell.Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -File """ & ps1Path & """", 0, True
