from peewee import *

connection = PostgresqlDatabase(
    database='middle-earth',
    user="postgres",
    password="postgres",
    host="127.0.0.1",
    port=5432
)

class Base(Model):
	class Meta:
		database = connection

class Battles(Base):
    id = IntegerField(column_name='id')
    name = CharField(column_name='name')
    place = CharField(column_name='place')
    years_ago = IntegerField(column_name='yearsago')
    reason = CharField(column_name='reason')
    duration = IntegerField(column_name='duration')

    class Meta:
        table_name = 'battles'

class Dwarfs(Base):
    id = IntegerField(column_name='id')
    name = CharField(column_name='name')
    gender = CharField(column_name='gender')
    height = IntegerField(column_name='height')
    beird = IntegerField(column_name='beird')
    skill = CharField(column_name='skill')
    weight = IntegerField(column_name='weight')
    age = IntegerField(column_name='age')

    class Meta:
        table_name = 'dwarfs'

class Hobbits(Base):
    id = IntegerField(column_name='id')
    name = CharField(column_name='name')
    surname = CharField(column_name='surname')
    residence = CharField(column_name='residence')
    _class = CharField(column_name='class')
    height = IntegerField(column_name='height')
    weight = IntegerField(column_name='weight')
    age = IntegerField(column_name='age')
    gender = CharField(column_name='gender')
    adventure = IntegerField(column_name='adventure')

    class Meta:
        table_name = 'hobbits'

class Humans(Base):
    id = IntegerField(column_name='id')
    name = CharField(column_name='name')
    gender = CharField(column_name='gender')
    age = IntegerField(column_name='age')
    country = CharField(column_name='country')
    skill = CharField(column_name='skill')
    purpose = CharField(column_name='purpose')

    class Meta:
        table_name = 'humans'

class Orcs(Base):
    id = IntegerField(column_name='id')
    name = CharField(column_name='name')
    master = CharField(column_name='master')
    danger = IntegerField(column_name='danger')
    endurance = IntegerField(column_name='endurance')
    bravery = IntegerField(column_name='bravery')

    class Meta:
        table_name = 'orcs'

def query1():
    dobik = Dwarfs.get(Dwarfs.id == 2) # dobik
    print('1. Однотабличный запрос на выборку:')
    # print(dobik.id, dobik.name, dobik.skill)

    query = Dwarfs.select().where(Dwarfs.age > 398).order_by(Dwarfs.name)
    print(f"Запрос: {query}")
    result = query.dicts().execute()
    print("Результат:")
    for elem in result:
        print(elem)

def query2():
    print('2. Многотабличный запрос на выборку:')
    query = Hobbits.select(Hobbits.id, Hobbits.height)\
        .join(Dwarfs, on=(Dwarfs.height == Hobbits.height))\
        .order_by(Hobbits.height)\
        .limit(5)
    result = query.dicts().execute()
    print("Результат:")
    for elem in result:
        print(elem)

def print_last_dwarfs():
    print("Последние 3 дварфа:")
    query = Dwarfs.select().limit(3).order_by(Dwarfs.id.desc())
    result = query.dicts().execute()
    for elem in result:
        print(elem)

def add_dwarf(new_id, new_name, new_gender, new_height, new_beird, new_skill, new_weight, new_age):
    global connection

    try:
        with connection.atomic() as con:
            Dwarfs.create(
                id=new_id,
                name=new_name,
                gender=new_gender,
                height=new_height,
                beird=new_beird,
                skill=new_skill,
                weight=new_weight,
                age=new_age
            )
            print("Дварф успешно добавлен!")
    except:
        print("Такой дварф уже существует")
        con.rollback()

def grow_beard(d_id):
    try:
        d = Dwarfs.get(Dwarfs.id == d_id)
        d.beird = d.beird + 5
        d.save()
        print("Борода дварфа выросла!")
    except:
        print("Всё, борода упёрлась в пол!")

def query3():
    new_id = 9999
    print('3. Три запроса на добавление, изменение и удаление данных в базе данных:')
    print_last_dwarfs()
    add_dwarf(new_id, "Lucky dwarf", "Leprecon", "50", "10", "Gambler", "50", "50")
    print_last_dwarfs()
    grow_beard(new_id)
    print_last_dwarfs()

def query4():
    global connection
    cursor = connection.cursor()
    print_last_dwarfs()
    cursor.execute("CALL cut_beird(9999);")
    connection.commit()
    print_last_dwarfs()
    cursor.close()


def task3():
    global connection

    query1()
    query2()
    query3()
    query4()

    connection.close()

task3()