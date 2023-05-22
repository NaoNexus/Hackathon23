from utilities import read_json
from helpers.line import Line


class DialogueHelper:
    json: list
    lines: list
    authors: list

    index: int

    def __init__(self):
        self.json = read_json('dialogue.json')
        self.lines: list = []

        self.actors = self.json['actors']

        for line in self.json['dialogue']:
            self.lines.append(Line.from_json(line))

        self.lines.sort(key=lambda line: line.index)

        self.authors = []

    def next_index(self, author) -> list:
        if len(self.authors) > 1:
            self.authors.remove(author)
            return ['none']
        else:
            if (len(self.authors) != 0):
                self.authors.remove(author)
            self.index += 1

            authors = []

            for line in self.lines:
                if line.index == self.index:
                    authors.append(line)

            self.authors.extend(map(authors, lambda author: author.author))

            return [map(authors, lambda author: f'server_{author.message}_{author.author}')]
