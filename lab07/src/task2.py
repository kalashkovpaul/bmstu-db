from dwarf import dwarf
import json
from types import SimpleNamespace
import psycopg2

def connect():
    connection = None
    try:
        connection = psycopg2.connect(
            database="middle-earth",
            user="postgres",
            password="postgres",
            host="127.0.0.1",
            port="5432"
        )
    except:
        print("Ошибка при подскючении к БД")
    print("Подключение к БД успешно")
    return connection

def print_json(array):
    for elem in array:
        print(json.dumps(elem.get()))

def read_json(filename, count=10):
    file = open(filename, 'r')
    data = ""
    for line in file:
        data += line
    info = json.loads(data)
    info = info[:count]
    array = list()
    for elem in info:
        array.append(dwarf(
            elem['id'],
            elem['name'],
            elem['gender'],
            elem['height'],
            elem['beird'],
            elem['skill'],
            elem['weight'],
            elem['age']
        ))

    for d in array:
        print(d)
    return array

def grow_beard(dwarfs, id):
    for d in dwarfs:
        if d.id == id:
            d.beird += 5
    print_json(dwarfs)

def add_dwarf(dwarfs, d):
    dwarfs.append(d)
    print_json(dwarfs)

def task2():
    connection = connect()
    cur = connection.cursor()
    print("Чтение из JSON:")
    dwarf_array = read_json("lab07/src/json/dwarfs.json")
    print("Обновление JSON:")
    grow_beard(dwarf_array, 2)
    print()
    print("Добавление в JSON:")
    add_dwarf(dwarf_array, dwarf(777, "Lucky dwarf", "Leprecon", "50", "50", "Gambler", "50", "50"))
    cur.close()
    connection.close()
task2()