# File to test socket
import socket

IP = 'localhost'
PORT = 5050

if __name__ == '__main__':
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((IP, PORT))
        s.listen()

        conn, addr = s.accept()
        
        with conn:
            print(f"Connected by {addr}")
            while True:
                user = input()

                data = conn.recv(1024)

                if data:
                    print(data)

                if user:
                    conn.sendall(data)