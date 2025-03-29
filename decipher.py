import os
import sqlite3
from Cryptodome.Cipher import AES
import base64

def decrypt_password(encrypted_password, key):
    try:
        # Comprobar si la contraseña está cifrada con AES-GCM
        if encrypted_password[:3] == b'v10':  # Prefijo típico de Chrome
            nonce = encrypted_password[3:15]
            ciphertext = encrypted_password[15:-16]
            tag = encrypted_password[-16:]
            cipher = AES.new(key, AES.MODE_GCM, nonce)
            return cipher.decrypt_and_verify(ciphertext, tag).decode('utf-8')
        else:
            # Método anterior con DPAPI (por compatibilidad con versiones antiguas)
            return win32crypt.CryptUnprotectData(encrypted_password, None, None, None, 0)[1]
    except Exception as e:
        return f"Error al descifrar: {e}"

def extract_passwords(db_path, key):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    cursor.execute("SELECT origin_url, username_value, password_value FROM logins")
    for row in cursor.fetchall():
        origin_url = row[0]
        username = row[1]
        encrypted_password = row[2]
        decrypted_password = decrypt_password(encrypted_password, key)
        print(f"URL: {origin_url}\nUsuario: {username}\nContraseña: {decrypted_password}\n{'-'*50}")
    cursor.close()
    conn.close()

def main(keyb64,db):
    key_input = keyb64
    key = base64.b64decode(key_input)

    db_path = db

    if not os.path.exists(db_path):
        print(f"El archivo {db_path} no existe.")
        return

    extract_passwords(db_path, key)

#main()
