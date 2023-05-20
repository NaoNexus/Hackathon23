import psycopg2
import helpers.config_helper as config_helper
from helpers.logging_helper import logger
from helpers.file_helper import FileHelper
from utilities import json_to_beach, json_to_user

import os
from datetime import datetime


class DB:
    file_helper: FileHelper

    def __init__(self, config: config_helper.Config):
        self.file_helper = FileHelper()

        try:
            self.connection = psycopg2.connect(host=config.db_host, database=config.db_name,
                                               user=config.db_user, password=config.db_password)
        except Exception as e:
            logger.error(str(e))

        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    CREATE TABLE IF NOT EXISTS Users(
                        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
                        nickname TEXT NOT NULL UNIQUE,
                        name TEXT,
                        surname TEXT,
                        password TEXT NOT NULL
                        );''')

                cur.execute('''
                    CREATE TABLE IF NOT EXISTS Beaches(
                        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
                        "dateReported" TEXT NOT NULL,
                        "dateCleaned" TEXT,
                        latitude NUMERIC(8, 6) NOT NULL,
                        longitude NUMERIC(8, 6) NOT NULL,
                        details TEXT NOT NULL,
                        "dirtyImageExtension" TEXT NOT NULL,
                        "cleanImageExtension" TEXT,
                        "userReported" TEXT NOT NULL,
                        "userCleaned" TEXT,
                        CONSTRAINT fk_reported_user
                            FOREIGN KEY("userReported")
	                            REFERENCES users(nickname)
	                            ON DELETE CASCADE
                                ON UPDATE CASCADE,
                        CONSTRAINT fk_cleaned_user
                            FOREIGN KEY("userCleaned")
	                            REFERENCES users(nickname)
	                            ON DELETE CASCADE
                                ON UPDATE CASCADE
                        );''')

        self.get_beach_report('')

    def get_user_by_id(self, id):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    SELECT * FROM Users
                    WHERE id::text = %s;''',
                            (str(id),))

                if (cur.rowcount == 0):
                    return {}
                for tupla in cur:
                    return json_to_user(tupla)

    def get_user_by_nickname(self, nickname):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    SELECT * FROM Users
                    WHERE nickname = %s;''',
                            (nickname,))

                if (cur.rowcount == 0):
                    return {}
                for tupla in cur:
                    return json_to_user(tupla)

    def get_user_by_nickname_and_password(self, nickname, password):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    SELECT * FROM Users
                    WHERE nickname = %s AND password = %s;''',
                            (nickname, password))

                if (cur.rowcount == 0):
                    return {}
                for tupla in cur:
                    return json_to_user(tupla)

    def save_user(self, user):
        with self.connection:
            with self.connection.cursor() as cur:
                if (user.get('id', '') == ''):
                    cur.execute('''
                        INSERT INTO Users(nickname, name, surname, password)
                        VALUES ( %s, %s, %s, %s);''',
                                ((user['nickname']), user['name'], user['surname'], user['password']))

                else:
                    cur.execute('''
                        UPDATE Users
                        SET nickname = %s, name = %s, surname = %s, password = %s
                        WHERE id::text = %s;''',
                                (user['nickname'], user['name'], user['surname'], user['password'], user['id']))

                return cur.statusmessage

    def delete_user_by_id(self, id):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    DELETE FROM Users
                    WHERE id::text = %s;''',
                            (str(id),))

                return cur.statusmessage

    def delete_user_by_nickname(self, nickname):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    DELETE FROM Users
                    WHERE nickname = %s;''',
                            (nickname,))

                return cur.statusmessage

    def save_beach_report(self, report):
        with self.connection:
            with self.connection.cursor() as cur:
                if (report.get('dateReported', '') == ''):
                    report['dateReported'] = datetime.now().isoformat()

                if (report.get('id', '') == ''):
                    cur.execute('''
                        INSERT INTO Beaches("dateReported", "dateCleaned", latitude, longitude, details, "dirtyImageExtension", "cleanImageExtension", "userReported", "userCleaned")
                        VALUES ( %s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id; ''',
                                (report['dateReported'].split('.')[0], report.get('dateCleaned', '').split('.')[0], report['latitude'], report['longitude'], report.get('details', ''), report.get('dirtyImageExtension', ''), report.get('cleanImageExtension', ''), report['userReported'], report.get('userCleaned', None),))

                    for tupla in cur:
                        report['id'] = tupla[0]

                    self.file_helper.save_beach_report_images(report)

                else:
                    cur.execute('''
                        UPDATE Beaches
                        SET "dateReported" = %s, "dateCleaned" = %s, latitude = %s, longitude = %s, details = %s, "dirtyImageExtension" = %s, "cleanImageExtension" = %s, "userReported" = %s, "userCleaned" = %s
                        WHERE id::text = %s; ''',
                                (report['dateReported'].split('.')[0], report.get('dateCleaned', '').split('.')[0], report['latitude'], report['longitude'], report.get('details', ''), report['dirtyImageExtension'], report.get('cleanImageExtension', ''), report['userReported'], report.get('userCleaned', ''), report['id']))

                    self.file_helper.save_beach_report_images(report)

                return cur.statusmessage

    def get_beaches_reports(self):
        with self.connection:
            with self.connection.cursor() as cur:
                data = []
                cur.execute('''
                    SELECT * FROM Beaches
                    ORDER BY "dateReported" ASC;''')

                for tupla in cur:
                    beach_report = json_to_beach(tupla)
                    beach_report = self.file_helper.save_beach_report_images(
                        beach_report)
                    data.append(beach_report)

                return data

    def get_beach_report(self, id):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    SELECT * FROM Beaches
                    WHERE id::text = %s
                    ORDER BY "dateReported" ASC;''',
                            (str(id),))

                if (cur.rowcount == 0):
                    return {}
                for tupla in cur:
                    beach_report = json_to_beach(tupla)
                    return self.file_helper.save_beach_report_images(
                        beach_report)

    def delete_beach_report(self, id):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    DELETE FROM Beaches
                    WHERE id::text = %s;''',
                            (str(id),))

                return cur.statusmessage
