from helpers.config_helper import Config
from helpers.logging_helper import logger
from helpers.web_browser_helper import WebBrowser

import sys
import socket
from threading import Thread
from typing import List


class SocketClient:
    def __init__(self, connection, ip, port, on_message):
        self.ip = ip
        self.connection = connection
        self.port = port
        self.on_message = on_message

    def run(self):
        while True:
            message = self.connection.recv(1024).decode("utf-8")
            message.strip()

            if message:
                logger.info(
                    f'Received message from (IP: {self.ip}, Port: {self.port}): {self.ip}: {message}')

                self.on_message(message)


class SocketServer:
    ip: str
    port: int

    ''' Possible codes:
    * -1: NAO is moving
    *  0: NAO is in home base
    * 1-10: Number of painting described
    '''
    status: int

    clients: List[SocketClient] = []

    s: socket.socket

    def __init__(self, config: Config):
        self.ip = config.socket_ip
        self.port = config.socket_port

        self.start_server()

    def start_server(self):
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        self.s.bind((self.ip, self.port))
        self.s.listen(1)

        logger.info(f'Socket server started')

        try:
            while True:
                conn, (ip, port) = self.s.accept()

                logger.info(
                    f'New client connected (IP: {ip}, Port: {port})')

                Thread(target=self.on_new_client, args=(
                    conn, ip, port), daemon=True).start()
        except KeyboardInterrupt:
            self.s.close()
            sys.exit(0)
        except Exception as e:
            logger.info(str(e))

            self.s.close()
            sys.exit(1)

    def send_to_all_clients(self, msg):
        for client in self.clients:
            client.connection.sendall(msg.encode())

        logger.info(f'Sent broadcast message: {msg}')

    def on_new_client(self, conn, ip, port):
        client = SocketClient(conn, ip, port, self.on_received_message)

        self.clients.append(client)

        try:
            client.run()
        except Exception as e:
            logger.error(str(e))

            client.connection.close()

        self.clients.remove(client)

    def on_received_message(self, message):
        self.send_to_all_clients(message)
        manage_message(message)


def manage_message(message):
    source, body, destination = message.split('_')

    if (source == 'app' and destination == 'arduino' and body in [str(i) for i in range(1, 11)]):
        status = -1
    elif ('arduino' in source and 'nao' in destination and body in [str(i) for i in range(1, 11)]):
        status = int(body)
        WebBrowser.open_window(body)
    elif (source == 'nao' and destination == 'arduino' and body in [str(i) for i in range(1, 11)]):
        status = -1
        WebBrowser.close_window()
    elif (source == 'arduino' and destination == 'app' and body in [str(i) for i in range(1, 11)]):
        status = 0
