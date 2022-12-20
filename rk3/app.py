from time import *
from peewee import *
import datetime

from datetime import *


TASK_2_1 = """
select department
from employee
group by department
having count(id) > 10;
"""

TASK_2_2 = """
select id
from employee
where id not in(
	select employee_id
	from (
		select employee_id, rdate, rtype, count(*)
		from record
		group by employee_id, rdate, rtype
		having rtype=2 and count(*) > 1
		) as tmp
);
"""

TASK_2_3 = """
// ниже в виде строки для форматирования
"""

con = PostgresqlDatabase(
    database="postgres",
    user="root",
    password="postgres",
    host="127.0.0.1",
    port=5432
)
class BaseModel(Model):
    class Meta:
        database = con


class Employee(BaseModel):
    id = IntegerField(column_name='id')
    fullname = CharField(column_name='fullname')
    birthdate = DateField(column_name='birthdate')
    department = CharField(column_name='department')

    class Meta:
        table_name = 'employee'


class Record(BaseModel):
    employee_id = ForeignKeyField(Employee, on_delete="cascade")
    rdate = DateField(column_name='rdate')
    dayweek = CharField(column_name='dayweek')
    rtime = TimeField(column_name='rtime')
    rtype = IntegerField(column_name='rtype')

    class Meta:
        table_name = 'record'


def output(cur):
    rows = cur.fetchall()
    for elem in rows:
        print(*elem)
    print()


def print_query(query):
	u_b = query.dicts().execute()
	for elem in u_b:
		print(elem)


def task_sql():
    global con

    cur = con.cursor()

    cur.execute(TASK_2_1)
    print("Запрос 2.1 (SQL команда):")
    output(cur)

    cur.execute(TASK_2_2)
    print("Запрос 2(SQL команда):")

    output(cur)

    print("Запрос 3(SQL команда):")
    dat = input("Введите дату: (ГГГГ-ММ-ДД) ")
    query = '''
            select distinct department
            from employee
            where id in
            (
                select employee_id
                from
                (
                    select employee_id, min(rtime)
                    from record
                    where rtype = 1 and rdate = %s
                    group by employee_id
                    having min(rtime) > '9:00'
                ) as tmp
            );'''
    cur.execute(query, (dat, ))
    output(cur)

    cur.close()

def task_1_app():
    print("Запрос 1(на уровне приложения): ")
    now = datetime.now()
    now = now.strftime("%Y-%m-%d")
    query = Employee\
        .select(Employee.department)\
        .group_by(Employee.department)\
        .having(fn.Count(Employee.id) > 10)
    print_query(query)

# Найти сотрудников, которые не выходят с рабочего места
# в течение всего рабочего дня
def task_2_app():
    data = '2022-12-20'
    print("Запрос 2 (на уровне приложения):")

    t1 = Record\
        .select(Record.employee_id, Record.rdate)\
        .where(Record.rtype == 1)\
        .where(Record.rdate == data)\
        .group_by(Record.employee_id, Record.rdate)\
        .having(fn.count(Record.employee_id) == 1).alias('res1')
    t2 = Record\
        .select(Record.employee_id, Record.rdate)\
        .where(Record.rtype == 2)\
        .where(Record.rtime >= '18:00')\
        .group_by(Record.employee_id, Record.rdate)\
        .having(fn.count(Record.employee_id) == 1).alias('res2')

    res = Employee\
        .select(fn.Distinct(Employee.id), Employee.id)\
        .join(t1, on=Employee.id == SQL('res1.employee_id'))\
        .join(t2, on=Employee.id == SQL('res2.employee_id'))\

    # ПРИМЕЧАНИЕ: далее идёт способ, в котором получаемый запрос имеет ту же структуру,
    # что и запрос на SQL для этого задания (см. выше). ОДНАКО он работает лишь из-за
    # найденного случайно "хака" по тому, как делать запросы с подзапросами - посредством
    # костыльного и захардкоженного написания алиаса t2, который для peewee является
    # системным алиасом. Поэтому, если запустить лишь query (без res) то это не сработает.
    # Оставил код ниже просто потому, что не хочется удалять, не зря же его писал)
    # Способ выше, тем не менее, для учёта сотрудников требует, чтобы сотрудник имел
    # ровно одну запись входа и ровно одну запись выхода

    # query = Record\
    #     .select(Record.employee_id)\
    #     .from_(Record\
    #         .select(Record.employee_id, Record.rdate, Record.rtype, fn.count(Record.employee_id))\
    #         .group_by(Record.employee_id, Record.rdate, Record.rtype)\
    #         .having(Record.rtype == 2, fn.count(Record.employee_id) > 1).alias('t2'))


    # res = Employee\
    #     .select(Employee.id)\
    #     .where(Employee.id.not_in(query))
    # print(res)

    print_query(res)


# Найти все отделы, в которых есть сотрудники, опоздавшие \
# в определенную дату. Дату передавать с клавиатуры
def task_3_app():
    print("Задание 3 (на уровне приложения")
    dat = input("Введите дату: (ГГГГ-ММ-ДД) ")

    res = (Employee
            .select(fn.Distinct(Employee.department), Employee.department)\
            .from_(Record\
                    .select(SQL('employee_id'), SQL('rdate'), SQL('rtime'), SQL('rdate'), SQL('rtype'), SQL('num'))\
                    .from_(Record
                            .select(Record.employee_id.alias('employee_id'), Record.rdate.alias('rdate'), Record.rtime.alias('rtime'),
                                Record.rtype.alias('rtype'),
                                fn.RANK().over(partition_by=[Record.employee_id, Record.rdate], order_by=[Record.rtime]).alias('num'))\
                            .where(Record.rtype == 1))\
                    .where(SQL('rtime') > '09:00:00')\
                    .where(SQL('num') == 1)\
                    .where(SQL('rdate') == dat))\
            .join(Employee, on=Employee.id == SQL('employee_id'))\
            .group_by(Employee.department))
    print_query(res)

def main():
    task_sql()
    task_1_app()
    task_2_app()
    task_3_app()


if __name__ == '__main__':
    main()