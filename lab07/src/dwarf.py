class dwarf():
    id = int()
    name = str()
    gender = str()
    height = int()
    beird = int()
    skill = str()
    weight = int()
    age = int()

    def __init__(self, id, name, gender, height, beird, skill, weight, age):
        self.id = id
        self.name = name
        self.gender = gender
        self.height = height
        self.beird = beird
        self.skill = skill
        self.weight = weight
        self.age = age

    def get(self):
        return {
            'id': self.id,
            'name': self.name,
            'gender': self.gender,
            'height': self.height,
            'beird': self.beird,
            'skill': self.skill,
            'weight': self.weight,
            'age': self.age
        }

    def __str__(self):
        s = f"id: {self.id}, name: {self.name}, gender: {self.gender}, height: {self.height}, beird: {self.beird}, weight: {self.weight}, age: {self.age}"
        return s

def create_users(filename):
    file = open(filename, 'r')
    users = list()
    for line in file:
        args = line.split(',')
        args[0], args[3], args[4], args[6], args[7] =\
            int(args[0]), int(args[3]), int(args[4]), int(args[6]), int(args[7])
        users.append(dwarf(*args).get())
    return users
