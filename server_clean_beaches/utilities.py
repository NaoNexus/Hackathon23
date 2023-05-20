import time
import yaml

from datetime import timedelta
from dateutil import parser


def getElapsedTime(startTime):
    elapsedTime = time.time() - startTime

    hours = elapsedTime // 360
    minutes = (elapsedTime - hours * 360) // 60
    seconds = (elapsedTime - hours * 360 - minutes * 60)

    return f'{int(hours)}h {int(minutes)}m {int(seconds)}s'


def read_yaml(file_path):
    with open(file_path, 'r') as f:
        return yaml.safe_load(f)


def solar_intensity_to_lux(solar_intensity):
    return solar_intensity / 0.0079


def extract_date(string):
    return string.split('T')[0]


def extract_date_hour(string):
    string = string.split(':')[0]
    return f'{string}:00'


def next_day(date_string):
    date = parser.parse(date_string)

    date += timedelta(days=1)

    return date.isoformat()


def json_to_beach(json):
    return {'id': json[0],
            'dateReported': json[1],
            'dateCleaned': json[2],
            'latitude': json[3],
            'longitude': json[4],
            'details': json[5],
            'dirtyImageExtension': json[6],
            'cleanImageExtension': json[7],
            'userReported': json[8],
            'userCleaned': json[9]}


def json_to_user(json):
    return {
        'id': json[0],
        'nickname': json[1],
        'name': json[2],
        'surname': json[3],
    }
