-- 1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
-- данные в  XML  (MSSQL) или  JSON(Oracle,  Postgres). Для выгрузки в  XML
-- проверить все режимы конструкции FOR XML

select row_to_json(b) result from battles b
select row_to_json(d) result from dwarfs d
select row_to_json(h) result from hobbits h
select row_to_json(h) result from humans h
select row_to_json(o) result from orcs o

-- 2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

CREATE TABLE IF NOT EXISTS battles_copy
(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(50) DEFAULT 'Lost',
    place VARCHAR(20) DEFAULT 'Lost Lands',
    yearsAgo INT CHECK (yearsAgo > 0 AND yearsAgo < 8001),
    reason VARCHAR(20) DEFAULT 'Lost',
    duration INT NOT NULL
);

\copy (select row_to_json(b) result from battles b) to '/home/paul/Desktop/bmstu-db/lab05/battles.json'; -- from psql in pgAdmin

create table if not exists battles_import(doc json)

\copy battles_import from '/home/paul/Desktop/bmstu-db/lab05/battles.json'; -- from psql with sudo or pgAdming's psql

select * from battles_import

select * from battles_import, json_populate_record(null::battles_copy, doc);

insert into battles_copy
select id, name, place, yearsAgo, reason, duration
from battles_import, json_populate_record(null::battles_copy, doc);

select * from battles_copy

-- 3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
-- добавить атрибут с типом  XML или  JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд  INSERT
-- или UPDATE.

create table if not exists test_table
(
	data json
)

select * from test_table

insert into test_table
select * from json_object('{test_id, test_data}', '{1, "data"}');

-- 4.1 Извлечь  XML/JSON фрагмент из XML/JSON документа

create table if not exists test_data
(
	id INT,
	name VARCHAR
)

select * from battles_import, json_populate_record(null::test_data, doc);

select id, name
from battles_import, json_populate_record(null::test_data, doc)
where name like 'Siege%'

select doc->'id' as id, doc->'name' as name
from battles_import

-- 4.2 Извлечь значения конкретных узлов или атрибутов XML/JSON документа

select doc->'id' as id, doc->'name' as name
from battles_import

-- 4.3 Выполнить проверку существования узла или атрибута

create table soldiers(doc jsonb);
drop table soldiers;

insert into soldiers values('{"id": 0, "weapon": {"hand": "gun", "belt": "grenade"}}');
insert into soldiers values('{"id": 1, "weapon": {"hand": "knife", "belt": "big knife"}}');

create or replace function get_soldier(u_id jsonb)
returns varchar as '
	select case
		when count.cnt > 0
			then ''true''
		else ''false''
		end as comment
	from (
		select count(doc -> ''id'') cnt
		from soldiers
		where doc -> ''id'' @> u_id
	) as count
' language sql

select * from soldiers
select get_soldier('1') -- true
select get_soldier('2') -- false

-- 4.4 Изменить XML/JSON документ




