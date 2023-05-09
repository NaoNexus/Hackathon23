class Line:
    index: int
    actor: str
    message: str

    def __init__(self, index, actor, message) -> None:
        self.index = index
        self.actor = actor
        self.message = message

    @staticmethod
    def from_json(json_dct):
        return Line(json_dct['index'], json_dct['actor'], json_dct['message'])
