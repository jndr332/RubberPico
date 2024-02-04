'Instalación de python sigilosamente 

# Descargar el instalador de Python
$url = "https://www.python.org/ftp/python/3.10.2/python-3.10.2-amd64.exe"
$output = "$env:TEMP\python-3.10.2-amd64.exe"
Invoke-WebRequest -Uri $url -OutFile $output

# Ejecutar el instalador de Python
Start-Process -FilePath $output -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1" -Wait

# Eliminar el instalador descargado
Remove-Item $output



'Reinicia la consola y ya se podra leer en el path -

