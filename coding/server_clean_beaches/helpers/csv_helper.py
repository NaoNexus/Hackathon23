import csv


class CsvHelper:
    index: int

    def __init__(self):
        self.index = 1

    def get_next_csv(self):
        result = self.get_csv(self.index)
        self.index += 1

        if (self.index > 10):
            self.index = 1

        return result

    def get_csv(self, index):
        json = []

        with open(f'csv/boat_{index}.csv', newline="\n") as file:
            boats = csv.reader(file, delimiter=";")
            next(boats)

            for boat in boats:
                json.append({
                    "id": boat[0],
                    "latitude": boat[1],
                    "longitude": boat[2],
                    "type": boat[3],
                    "fuel": boat[4],
                })

        return json

    def get_boat_pollution(self, json):
        fuel_type = json['fuel']
        boat_type = json['type']

        pollution = 0

        if fuel_type == 'gnl':
            pollution = 1
        elif fuel_type == 'crociera':
            pollution = 2
        elif fuel_type == 'benzina':
            pollution = 3

        if boat_type == 'motoscafo':
            pollution *= 1.5
        elif boat_type == 'peschereccio':
            pollution *= 2
        elif boat_type == 'traghetto':
            pollution *= 2.5
        elif boat_type == 'crociera':
            pollution *= 4
        elif boat_type == 'container_cargo':
            pollution *= 5
        elif boat_type == 'gas_cargo':
            pollution *= 5
        elif boat_type == 'veicoli_cargo':
            pollution *= 5.5

        return pollution

    def get_boats_pollution(self, json):
        pollution = 0

        for boat in json:
            pollution += self.get_boat_pollution(boat)

        return pollution
