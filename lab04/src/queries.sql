select * from pg_language;

create extension plpython3u; -- sudo apt-get update && sudo apt-get install postgresql-plpython3-XX, XX - version

-- 1. Определяемая пользователем скалярная функция CLR

create or replace function get_dwarf(d_id int = 0)
returns varchar
as $$
res = plpy.execute(f" \
    select * \
	from dwarfs \
	where id = {d_id};")
if res:
    return res[0]['name']
$$ LANGUAGE plpython3u;

select * from get_dwarf(1) as "First dwarf";

-- 2. Пользовательская агрегатная функция CLR

create or replace function count_skill(sk varchar)
returns int
as $$
count = 0
res = plpy.execute("select * from dwarfs")
for dwarf in res:
    if dwarf["skill"] == sk:
        count += 1
return count
$$ LANGUAGE plpython3u;

select * from count_skill('Barber');

select count(*) from dwarfs where skill = 'Barber';

-- 3. Определяемая пользователем табличную функцию CLR

create or replace function get_short_or_experienced_hobbits(req_height int, battle_years_ago int)
returns table (hobbit_id int, hobbit_height int)
as $$
experienced = plpy.execute(f" \
    select distinct h.id as hobbit_id, h.height as hobbit_height \
	from hobbits as h \
	join hob on h.id = hob.hobid \
	join battles on hob.bid = battles.id \
	where battles.yearsago > {battle_years_ago} and h.height < {req_height};")
return experienced
$$ LANGUAGE plpython3u;

select * from get_short_or_experienced_hobbits(97, 200);

-- 4. Хранимая процедура CLR

create or replace procedure insert_orc(
	id int,
	name varchar,
	master varchar,
	danger int,
	endurance int,
	bravery int
) as $$
# Чтобы использвать так так, нужно подругому назвать входные параметры.
# plpy.execute(f"insert into orcs values(...);")

# Функция plpy.prepare подготавливает план выполнения для запроса.
# Передается строка запроса и список типов параметров.
plan = plpy.prepare("insert into orcs values($1, $2, $3, $4, $5, $6)", ["int", "varchar", "varchar","int", "int", "int"])
rv = plpy.execute(plan, [id, name, master, danger, endurance, bravery])
$$ LANGUAGE plpython3u;

call insert_orc(5555, 'Perfect Orc', 'Sauron', 9, 9, 9);

select * from orcs where id = 5555;

-- 5. Триггер CLR

select * into hobbits_tmp
from hobbits;

create or replace function update_trigger()
returns trigger as $$
old_id = TD["old"]["id"]
old_weight = TD["old"]["weight"]
old_height = TD["old"]["height"]
new_height = TD["new"]["height"]
plpy.execute(f" \
	update hobbits_tmp \
	set weight = {old_weight} + 1 \
	where id = {old_id} and {old_height} <> {new_height};")
return "MODIFY"
$$ LANGUAGE plpython3u;

create or replace trigger log_update
after update on hobbits_tmp
for each row
execute procedure update_trigger();

select * from hobbits_tmp where name = 'Merry' and surname = 'Brandybuck';

update hobbits_tmp
set height = height + 1
where name = 'Merry' and surname = 'Brandybuck';

update hobbits_tmp
set weight = 90
where name = 'Merry' and surname = 'Brandybuck';

-- 6. Определяемый пользователем тип данных CLR

create type skill_t as
(
	skill varchar,
	count int
);

create or replace function get_skill_info(sk varchar)
returns skill_t as $$
plan = plpy.prepare("\
	select skill, count(skill) as count\
	from dwarfs \
	where skill = $1 \
	group by skill", ["varchar"])
result = plpy.execute(plan, [sk])
return (result[0]["skill"], result[0]["count"])
$$ LANGUAGE plpython3u;

select * from get_skill_info('Barber')

