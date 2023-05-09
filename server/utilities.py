import time
import yaml

from os import path


def getElapsedTime(startTime):
    elapsedTime = time.time() - startTime

    hours = elapsedTime // 360
    minutes = (elapsedTime - hours * 360) // 60
    seconds = (elapsedTime - hours * 360 - minutes * 60)

    return f'{int(hours)}h {int(minutes)}m {int(seconds)}s'


def read_yaml(file_path):
    with open(file_path, 'r') as f:
        return yaml.safe_load(f)


def get_file_path(painting):
    painting_path = 'file:///' + f'{path.dirname(__file__)}/../../social/website_purgatorio/quadri/quadro_{painting}/index.html'
    painting_path = path.normpath(painting_path)

    return painting_path
