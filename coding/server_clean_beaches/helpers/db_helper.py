import psycopg2
import helpers.config_helper as config_helper
from helpers.logging_helper import logger
from utilities import json_to_beach, json_to_user

import os
from datetime import datetime


class DB:
    def __init__(self, config: config_helper.Config):
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

    def save_beach_report(self, report, dirty_image, clean_image):
        with self.connection:
            with self.connection.cursor() as cur:
                if (report.get('dateReported', '') == ''):
                    report['dateReported'] = datetime.now().isoformat()

                if (report.get('id', '') == ''):
                    cur.execute('''
                        INSERT INTO Beaches("dateReported", "dateCleaned", latitude, longitude, details, "userReported", "userCleaned")
                        VALUES ( %s, %s, %s, %s, %s, %s, %s) RETURNING id; ''',
                                (report['dateReported'].split('.')[0], report.get('dateCleaned', '').split('.')[0], report['latitude'], report['longitude'], report.get('details', ''), report['userReported'], report.get('userCleaned', None),))

                    for tupla in cur:
                        report['id'] = tupla[0]
                        
                    if not os.path.exists(f"images/{report['id']}/"):
                        os.mkdir(f"images/{report['id']}/")

                    if dirty_image != '' and dirty_image.filename != '':
                        dirty_image.save(f"images/{report['id']}/dirty.png")

                    if clean_image != '' and clean_image.filename != '':
                        clean_image.save(f"images/{report['id']}/clean.png")

                else:
                    cur.execute('''
                        UPDATE Beaches
                        SET "dateReported" = %s, "dateCleaned" = %s, latitude = %s, longitude = %s, details = %s, "userReported" = %s, "userCleaned" = %s
                        WHERE id::text = %s; ''',
                                (report['dateReported'].split('.')[0], report.get('dateCleaned', '').split('.')[0], report['latitude'], report['longitude'], report.get('details', ''), report['userReported'], report.get('userCleaned', ''), report['id']))
                    if not os.path.exists(f"images/{report['id']}/"):
                        os.mkdir(f"images/{report['id']}/")

                    if dirty_image != '' and dirty_image.filename != '':
                        dirty_image.save(f"images/{report['id']}/dirty.png")

                    if clean_image != '' and clean_image.filename != '':
                        clean_image.save(f"images/{report['id']}/clean.png")

                return cur.statusmessage

    def get_beaches_reports(self):
        with self.connection:
            with self.connection.cursor() as cur:
                data = []
                cur.execute('''
                    SELECT * FROM Beaches
                    ORDER BY "dateReported" DESC;''')

                for tupla in cur:
                    data.append(json_to_beach(tupla))

                return data

    def get_beach_report(self, id):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    SELECT * FROM Beaches
                    WHERE id::text = %s
                    ORDER BY "dateReported" DESC;''',
                            (str(id),))

                if (cur.rowcount == 0):
                    return {}
                for tupla in cur:
                    return json_to_beach(tupla)

    def delete_beach_report(self, id):
        with self.connection:
            with self.connection.cursor() as cur:
                cur.execute('''
                    DELETE FROM Beaches
                    WHERE id::text = %s;''',
                            (str(id),))

                return cur.statusmessage
