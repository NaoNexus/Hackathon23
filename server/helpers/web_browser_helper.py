import utilities

import webbrowser
import pyautogui


class WebBrowser:

    def __init__(self):
        pass

    @staticmethod
    def close_window():
        pyautogui.hotkey('Ctrl', 'W')

    @staticmethod
    def open_window(painting):
        webbrowser.open_new_tab(utilities.get_file_path(painting))
