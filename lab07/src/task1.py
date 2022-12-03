from py_linq import *
from dwarf import *

def query_1(dwarfs):
    return dwarfs\
        .where(lambda d: d['age'] > 398)\
        .order_by(lambda d: d['name'])\
        .select(lambda d: {d['name'], d['age']})

def query_2(dwarfs):
    return dwarfs.count(lambda d: d['age'] > 398)

def query_3(dwarfs):
    beird = Enumerable([{dwarfs.min(lambda d: d['beird']), dwarfs.max(lambda d: d['beird'])}])
    age = Enumerable([{dwarfs.min(lambda d: d['age']), dwarfs.max(lambda d: d['age'])}])
    result = Enumerable(beird).union(Enumerable(age), lambda d: d)
    return result

def query_4(dwarfs):
    return dwarfs.group_by(key_names=['skill'], key=lambda d: d['skill']).select(lambda g: {'skill': g.key.skill, 'amount': g.count()})

def query_5(dwarfs):
    drinks = Enumerable([
        {'id': 333, 'drink': 'ale'},
        {'id': 444, 'drink': 'beer'},
        {'id': 555, 'drink': 'brandy'}
    ])
    return dwarfs.join(drinks, lambda o_k: o_k['id'], lambda i_k: i_k['id'])

def task1():
    dwarfs = Enumerable(create_users('csv/dwarfs.csv'))

    print('Дварфы возрастом старше 398 лет, отсортированы по имени')
    for dwarf in query_1(dwarfs):
        print(dwarf)

    print(f"Количество дварфов старше 398 лет: {str(query_2(dwarfs))}")

    print("Минимальный и максимальный размеры бороды, возраст:")
    for dwarf in query_3(dwarfs):
        print(dwarf)

    print("Группировка дварфов по гильдиям:")
    for dwarf in query_4(dwarfs):
        print(dwarf)

    print("Пересечение дварфов и их напитков:")
    for dwarf in query_5(dwarfs):
        print(dwarf)

task1()