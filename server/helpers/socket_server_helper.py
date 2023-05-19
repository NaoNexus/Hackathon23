from helpers.config_helper import Config
from helpers.dialogue_helper import DialogueHelper
from helpers.logging_helper import logger

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

    clients: List[SocketClient] = []

    dialogue_helper: DialogueHelper

    s: socket.socket

    def __init__(self, config: Config):
        self.ip = config.socket_ip
        self.port = config.socket_port

        self.dialogue_helper = DialogueHelper()

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

        if (len(self.clients) == self.dialogue_helper.actors):
            self.dialogue_helper.next_index('')

        try:
            client.run()
        except Exception as e:
            logger.error(str(e))

            client.connection.close()

        self.clients.remove(client)

    def on_received_message(self, message):
        result = self.dialogue_helper.next_index(message.split('_')[0])
        if len(result) != 0 and result[0] != 'none':
            for message in result:
                self.send_to_all_clients(message)