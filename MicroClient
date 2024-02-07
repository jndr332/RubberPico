import socket
import sounddevice as sd
import numpy as np
import os
import time

def record_and_send_audio(client_socket):
    print("Esperando señal del servidor para grabar audio...")
    # Esperar la señal del servidor para iniciar la grabación
    server_signal = client_socket.recv(1024)

    if server_signal == b'START_RECORDING':
        print("Grabando audio. Esto puede llevar unos segundos...")
        fs = 44100
        dtype = 'int16'

        # Grabar durante 5 segundos
        audio_data = sd.rec(int(10 * fs), samplerate=fs, channels=2, dtype=dtype)
        sd.wait()

        # Enviar los datos de audio al servidor
        audio_data_bytes = audio_data.tobytes()
        client_socket.sendall(len(audio_data_bytes).to_bytes(4, byteorder='big'))  # Enviar longitud del audio
        client_socket.sendall(audio_data_bytes)  # Enviar datos de audio

        print("Audio grabado y enviado al servidor.")

def main():
    host = '50.16.56.238'
    port = 8083

    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect((host, port))

    # El cliente permanece en un bucle para recibir más comandos del servidor
    while True:
        record_and_send_audio(client_socket)

        # Esperar un breve período antes de la siguiente grabación
        time.sleep(1)

    # Cerrar la conexión al salir del bucle
    client_socket.close()

if _name_ == "_main_":
    main()
