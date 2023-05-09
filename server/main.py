from helpers.config_helper import Config
from helpers.socket_server_helper import SocketServer
from helpers.logging_helper import logger

if __name__ == '__main__':
    config_helper = Config()
    socket_helper = SocketServer(config_helper)
