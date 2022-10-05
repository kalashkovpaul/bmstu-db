-- 1. Инструкция select, использующая предикат сравнения.
select d.name
from dwarfs as d
where d.age = 350;

-- 2. Инструкция select, использующая предикат between.
select h.name, h.surname
from hobbits as h
where h.residence = 'Shire' and h.age between 33 and 50;

-- 3. Инструкция select, использующая предикат like.
select o.name, o.master
from orcs as o
where o.name like 'A%g';

-- 4. Инструкция select, использующая предикат in с вложенным подзапросом.
select h.id, h.name, h.skill
from humans as h
where h.id in (
	select humid
	from hub
	where bid = 1);

-- 5. Инструкция select, использующая предикат exists с вложенным подзапросом.
select d.id, d.name
from dwarfs as d
where exists (select battles.id from battles
			   join "db"
			   on "db".bid = battles.id and d.id = "db".did
			   and battles.duration > 3600);

-- 6. Инструкция select, использующая предикат сравнения с квантором.
select d.id, d.name, d.height
from dwarfs as d
where d.height >= all(select height from dwarfs);

-- 7. Инструкция select, использующая агрегатные функции в выражениях столбцов.
select avg(height) as "avg height", sum(age) / count(age) as "avg age"
from hobbits;

-- 8. Инструкция  select, использующая скалярные подзапросы в выражениях столбцов.
select h.id, h.name, h.surname,
	(select avg(duration) from
		battles join hob on battles.id = hob.bid and hob.hobid = h.id)
		as "avg duration"
from hobbits as h;

-- 9. Инструкция select, использующая простое выражение case.
select d.id, d.name, d.height, d.skill,
	case
		when d.height > 100 then 'tall'
		when d.height > 80 then 'average'
		when d.height > 60 then 'short'
		else 'very short'
	end as "height meaning"
from dwarfs as d;

-- 10. Инструкция select, использующая поисковое выражение case.
select d.id, d.name, d.height, d.beird
from dwarfs as d
order by
(case
	when d.height > 100 then d.beird
	else 0
 end) desc;

-- 11. Создание новой временной локальной таблицы из результирующего набора
-- данных инструкции select.

select d.id, d.name, d.height,
	case
		when d.height > 100 then 'tall'
		when d.height > 80 then 'average'
		when d.height > 60 then 'short'
		else 'very short'
	end as "height meaning"
inTO dwarfsHeight
from dwarfs as d;

-- 12. Инструкция select, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении from.

select d.name as name, d.height as height,
	case
		when d.height > 100 then 'tall'
		when d.height > 80 then 'average'
		when d.height > 60 then 'short'
		else 'very short'
	end as "height meaning",

	case
		when true then 'dwarf'
	end as kind

	from dwarfs as d
union
select h.name as name, h.height as height,
	case
		when h.height > 100 then 'tall'
		when h.height > 80 then 'average'
		when h.height > 60 then 'short'
		else 'very short'
	end as "height meaning",

	case
		when true then 'hobbit'
	end as kind
	from hobbits as h;

-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем
-- вложенности 3.

select b.id, b.name, b.reason
from battles as b
where b.id in (
	select hub.bid
	from hub
	where hub.humid in (
		select h.id
		from humans as h
		where h.age > (
			select avg(h.age)
			from humans as h
		)
	)
)

-- 14. Инструкция  SELECT, консолидирующая данные с помощью предложения
-- GROUP BY, но без предложения HAVING.

select o.master, o.danger,
	case
		when o.danger > 7 then 'very dangerous'
		when o.danger > 4 then 'dangerous'
		when o.danger > 1 then 'not very dangerous'
		else 'dead'
	end as "danger state"
from orcs as o
group by master, danger

-- 15. Инструкция  SELECT, консолидирующая данные с помощью предложения
-- GROUP BY и предложения HAVING.

select o.master, o.bravery,
	case
		when o.bravery > 7 then 'very brave'
		when o.bravery > 4 then 'brave'
		when o.bravery > 1 then 'not very brave'
		else 'goblin'
	end as "bravery state"
from orcs as o
group by master, bravery
having bravery > (
	select avg(orcs.bravery)
	from orcs
)

-- 16. Однострочная инструкция  INSERT, выполняющая вставку в таблицу одной
-- строки значений.

insert into orcs (id, name, master, danger, endurance, bravery)
values(1011, 'Mighty Orc', 'Dark Lord', 10, 10, 10)

select o.id, o.name, o.master
from orcs as o
where (o.name = 'Mighty Orc')

delete from orcs
where (orcs.name = 'Mighty Orc')

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
-- результирующего набора данных вложенного подзапроса.

insert into orcs (id, name, master, danger, endurance, bravery)
select h.id * 10, h.name,
case when true then 'Sauron (Nope)' end as master,
case when true then 1 end as danger,
case when true then 1 end as endurance,
case when true then 10 end as bravery
from hobbits as h
where h.name = 'Frodo' or h.name = 'Sam'

select o.id, o.name, o.master, o.danger, o.endurance, o.bravery
from orcs as o
where (o.name = 'Frodo' or o.name = 'Sam')

delete from orcs
where (orcs.name = 'Frodo' or orcs.name = 'Sam')

-- 18. Простая инструкция UPDATE.

select * from hobbits as h
where
	h.name = 'Peregrin' and h.surname = 'Tuk' or
	h.name = 'Merry' and h.surname = 'Brandybuck'

update hobbits
set "height" = "height" + 10
where
	"name" = 'Peregrin' and "surname" = 'Tuk'
	or "name" = 'Merry' and "surname" = 'Brandybuck'

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET.

select * from hobbits as h
where
	h.name = 'Peregrin' and h.surname = 'Tuk' or
	h.name = 'Merry' and h.surname = 'Brandybuck'

update hobbits
set "height" = (select avg(height) from dwarfs) + 5
where
	"name" = 'Peregrin' and "surname" = 'Tuk'
	or "name" = 'Merry' and "surname" = 'Brandybuck'

-- 20. Простая инструкция DELETE.

insert into orcs (id, name, master, danger, endurance, bravery)
values(1011, 'Mighty Orc', 'Dark Lord', 10, 10, 10)

select o.id, o.name, o.master
from orcs as o
where (o.name = 'Mighty Orc')

delete from orcs
where (orcs.name = 'Mighty Orc')

-- 21. Инструкция DELETE с вложенным коррелированным подзапросом в
-- предложении WHERE.

delete from orcs
where orcs.name in (
	select o.name
	from orcs as o
	where o.master like '%Nope%'
)


insert into orcs (id, name, master, danger, endurance, bravery)
select h.id * 10, h.name,
case when true then 'Sauron (Nope)' end as master,
case when true then 1 end as danger,
case when true then 1 end as endurance,
case when true then 10 end as bravery
from hobbits as h
where h.name = 'Frodo' or h.name = 'Sam'

select o.id, o.name, o.master, o.danger, o.endurance, o.bravery
from orcs as o
where (o.name = 'Frodo' or o.name = 'Sam')

-- 22. Инструкция SELECT, использующая простое обобщенное табличное
-- выражение

with tallHobbits(name, surname, residence, height) as (
	select h.name, h.surname, h.residence, h.height
	from hobbits as h
	where h.height > 80
)
select avg(th.height) as "Средний рост хоббитов ростом 80"
from tallHobbits as th

-- 23. Инструкция  SELECT, использующая рекурсивное обобщенное табличное
-- выражение.

with recursive dwarfshierarchy(id, name, skill, height, skilllevel) as
(
	select d2.id, d1.skill, d2.name, d1.height, 1 as skilllevel
	from
	(
		(select d.skill, max(height) as height
		from dwarfs as d
		group by d.skill) as d1

		inner join
		(select d.id, d.skill, d.height, d.name
		from dwarfs as d) as d2
		on (d1.skill = d2.skill and d1.height = d2.height)
	)

	union all
	select d3.id, d3.name, d3.skill, d3.height, d4.skilllevel + 1
	from dwarfs as d3, dwarfshierarchy as d4
)
select *
from dwarfshierarchy

-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()

select distinct h.residence, h."class",
	avg(h.height) over(partition by h."class", h.residence) as "avg height",
	min(h.height) over(partition by h."class", h.residence) as "min height",
	max(h.height) over(partition by h."class", h.residence) as "max height"
from hobbits as h

-- 25. Оконные фнкции для устранения дублей
-- Придумать запрос, в результате которого в данных появляются полные дубли.
-- Устранить дублирующиеся строки с использованием функции ROW_NUMBER().

with duplicates(residence, "class", "avg height", "min height", "max height") as (
	select h.residence, h."class",
		avg(h.height) over(partition by h."class", h.residence) as "avg height",
		min(h.height) over(partition by h."class", h.residence) as "min height",
		max(h.height) over(partition by h."class", h.residence) as "max height"
	from hobbits as h
)
select * from duplicates

with duplicates(residence, "class", "avg height", "min height", "max height") as (
	select h.residence, h."class",
		avg(h.height) over(partition by h."class", h.residence) as "avg height",
		min(h.height) over(partition by h."class", h.residence) as "min height",
		max(h.height) over(partition by h."class", h.residence) as "max height"
	from hobbits as h
),
cta(row_nu, residence, "class", "avg height", "min height", "max height") as (
	select row_number() over(
	partition by d.residence, d."class", d."avg height", d."min height", d."max height"
	order by d.residence, d."class", d."avg height", d."min height", d."max height"
	),
		d.residence, d."class", d."avg height", d."min height", d."max height"
	from duplicates as d
)
select residence, "class", "avg height", "min height", "max height"
from cta
where row_nu = 1

