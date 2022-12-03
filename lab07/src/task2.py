from dwarf import dwarf
import json
import psycopg2

def connect():
    connection = None
    try:
        connection = psycopg2.connect(
            database="middle-earth",
            user="paul",
            password="paul",
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

def read_json(cur, count=15):
    cur.execute("select * from dwarfs")
    rows = cur.fetchmany(count)
    array = list()
    for elem in rows:
        tmp = elem[0]
        array.append(dwarf(
            tmp['id'],
            tmp['name'],
            tmp['gender'],
            tmp['height'],
            tmp['skill'],
            tmp['weight'],
            tmp['age']
        ))

    print(*array, sep='\n')
    return array

def task2():
    connection = connect()
    cur = connection.cursor()
    print("Чтение из JSON:")
    dwarf_array = read_json(cur)

task2()