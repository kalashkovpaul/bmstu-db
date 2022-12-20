from time import time

import matplotlib.pyplot as plt
import psycopg2
import redis
import json
import threading
from random import randint
ID = 2022

def connection():
	# Подключаемся к БД.
    try:
        con = psycopg2.connect(
            database="postgres",
            user="root",
            password="postgres",
            host="127.0.0.1",  # Адрес сервера базы данных.
            port="5432"		   # Номер порта.
        )
    except:
        print("Ошибка при подключении к Базе Данных")
        return

    print("База данных успешно открыта")
    return con

class dwarf_listener(object):

  def __init__(self):
    self.redis = redis.Redis()
    self.sub = self.redis.pubsub()
    self.sub.psubscribe(['channel1'])

  def listen(self):
    for blob in self.sub.listen():
      if blob['type'] == "message":
        data    = json.loads(blob['data'])
        print(data)
        sender  = data['data']['sender']
        channel = data['data']['channel']
        text    = data['data']['message']




def get_dwarf_1(cur):
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    cache_value = redis_client.get("dwarfs_1")
    if cache_value is not None:
        redis_client.close()
        return json.loads(cache_value)

    cur.execute("select * from dwarfs")
    res = cur.fetchall()

    redis_client.set("dwarfs_1", json.dumps(res))
    redis_client.close()

    return res




# 1. Приложение выполняет запрос каждые 5 секунд на стороне БД.
def task_02(cur, id):
    threading.Timer(5.0, task_02, [cur, id]).start()

    cur.execute("select *\
                   from dwarfs\
                   where id = %s;", (id, ))

    result = cur.fetchall()

    return result


# 2. Приложение выполняет запрос каждые 5 секунд через Redis в качестве кэша.
def task_03(cur, id):
    threading.Timer(5.0, task_02, [cur, id]).start()

    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    # sub = dwarf_listener()
    # sub.listen()

    cache_value = redis_client.get("dwarfs_id_" + str(id))
    if cache_value is not None:
        redis_client.close()
        return json.loads(cache_value)

    cur.execute("select *\
                   from dwarfs\
                   where id = %s;", (id, ))

    result = cur.fetchall()
    data = json.dumps(result)
    print("FFFFFFFFFFFF")
    redis_client.set("dwarfs_id_" + str(id), data)
    redis_client.close()

    return result


def dont_do(cur):
    # print("simple\n")
    # threading.Timer(10.0, dont_do, [cur]).start()
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    t1 = time()
    cur.execute("select *\
                   from dwarfs\
                   where id = 2021;")
    t2 = time()

    result = cur.fetchall()

    data = json.dumps(result)
    cache_value = redis_client.get("d1")
    if cache_value is not None:
        pass
    else:
        redis_client.set("d1", data)


    t11 = time()
    redis_client.get("d1")
    t22 = time()

    redis_client.close()

    return t2 - t1, t22 - t11


def del_tour(cur, con):
    redis_client = redis.Redis()
    # print("delete\n")
    # threading.Timer(10.0, del_tour, [cur, con]).start()

    did = 2021 #randint(1, 1000)

    t1 = time()
    cur.execute("delete from dwarfs\
         where id = %s;", (did, ))
    t2 = time()

    t11 = time()
    redis_client.delete("d"+str(did))
    t22 = time()

    redis_client.close()

    con.commit()

    return t2-t1, t22-t11

def ins_tour(cur, con):
    redis_client = redis.Redis()
    # print("insert\n")
    # threading.Timer(10.0, ins_tour, [cur, con]).start()

    hid = 2021 #randint(1, 1000)

    global ID
    t1 = time()
    cur.execute("insert into dwarfs values("+ str(ID) + ", 'Test Dwarf', 'Male', 80, 30,'Warrior', 50, 150);")
    t2 = time()
    ID+=1

    cur.execute("select * from dwarfs\
         where id = %s;", (hid, ))
    result = cur.fetchall()

    data = json.dumps(result)
    t11 = time()
    redis_client.set("d"+str(hid), data)
    t22 = time()

    redis_client.close()

    con.commit()

    return t2-t1, t22-t11

def upd_tour(cur, con):

    redis_client = redis.Redis()
    # print("update\n")
    # threading.Timer(10.0, upd_tour, [cur, con]).start()

    hid = 2021 #randint(1000, 2000)

    t1 = time()
    cur.execute("UPDATE dwarfs SET height = 85 WHERE id = %s;", (hid, ))
    t2 = time()

    cur.execute("select * from dwarfs\
         where id = %s;", (hid, ))

    result = cur.fetchall()
    data = json.dumps(result)

    t11 = time()
    redis_client.set("d"+str(hid), data)
    t22 = time()

    redis_client.close()

    con.commit()

    return t2-t1, t22-t11

# гистограммы
def task_04(cur, con):
    # simple
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = dont_do(cur)
        t1 += b1
        t2 += b2
    print("simple 100 db redis", t1 / 1000, t2 / 1000)
    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("Без изменения данных")
    plt.show()

    # delete
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = del_tour(cur, con)
        t1 += b1
        t2 += b2
    print("delete 100 db redis", t1 / 1000, t2 / 1000)

    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("При удалении новых строк каждые 10 секунд")
    plt.show()

    # insert
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = ins_tour(cur, con)
        t1 += b1
        t2 += b2
    print("insert 100 db redis", t1 / 1000, t2 / 1000)

    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("При добавлении строк каждые 10 секунд")
    plt.show()

    # updata
    t1 = 0
    t2 = 0
    for i in range(1000):
        b1, b2 = upd_tour(cur, con)
        t1 += b1
        t2 += b2
    print("update 100 db redis", t1 / 1000, t2 / 1000)

    index = ["БД", "Redis"]
    values = [t1 / 1000, t2/ 1000]
    plt.bar(index,values)
    plt.title("При изменении строк каждые 10 секунд")
    plt.show()


def do_cache(cur):
    redis_client = redis.Redis(host="localhost", port=6379, db=0)

    for id in range(1000):
        cache_value = redis_client.get("d" + str(id))
        if cache_value is not None:
            redis_client.close()
            return json.loads(cache_value)

        cur.execute("select *\
                    from dwarfs\
                    where id = %s;", (id, ))

        result = cur.fetchall()
        print("FFFFFFFFFFFF")
        redis_client.set("d" + str(id), json.dumps(result))
        redis_client.close()

    return result

if __name__ == '__main__':
    con = connection()
    cur = con.cursor()

    # do_cache(cur)


    print("1. Дварфы (задание 2)\n"
          "2. Приложение выполняет запрос каждые 5 секунд на стороне БД. (задание 3.1)\n"
          "3. Приложение выполняет запрос каждые 5 секунд через Redis вкачестве кэша. (задание 3.2)\n"
          "4. Гистограммы (задание 3.3)\n"
          "\n0. Выход\n"
    )

    while True:
        c = int(input("Выбор: "))

        if c == 1:
            res = get_dwarf_1(cur)

            for elem in res:
                print(elem)

        elif c == 2:
            did = int(input("ID дварфа (от 0 до 2020): "))

            res = task_02(cur, did)

            for elem in res:
                print(elem)

        elif c == 3:
            did = int(input("ID дварфа (от 0 до 2020): "))

            res = task_03(cur, did)

            for elem in res:
                print(elem)

        elif c == 4:
            task_04(cur, con)
        elif c == 0:
            print("Спасибо, что пользовались этой программой")
            break
        else:
            print("Ошибка\n")


    cur.close()
