import cv2
import socket
import pickle
import struct
import time

def enviar_transmision(ip, puerto):
    cliente_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    cliente_socket.connect((ip, puerto))
    camara = cv2.VideoCapture(0)

    try:
        while True:
            ret, frame = camara.read()
            data = pickle.dumps(frame)
            msg_size = len(data)
            cliente_socket.sendall(struct.pack("I", msg_size) + data)
            time.sleep(0.1)  # Agregar un pequeño retraso

    finally:
        camara.release()
        cliente_socket.close()

if __name__ == "__main__":
    ip_receptor = '50.16.56.238'  # Reemplaza con la IP del receptor
    puerto_receptor = 5012  # Reemplaza con el puerto del receptor
    enviar_transmision(ip_receptor, puerto_receptor)
