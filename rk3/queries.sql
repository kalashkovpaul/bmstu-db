create table employee (
	id int not null primary key,
	fullname varchar,
	birthdate date,
	department varchar
);

create table record(
	employee_id int references employee(id) not null,
	rdate date,
	dayweek varchar,
	rtime time,
	rtype int
);


insert into employee(
	id,
	fullname,
	birthdate,
	department
) values
	(1, 'fullname1', '25-09-1995', 'IT'),
	(2, 'fullname2', '30-09-1999', 'IT'),
	(3, 'fullname3', '25-09-1990', 'Fin'),
	(4, 'fullname4', '15-09-1997', 'Fin');


insert into employee(
	id,
	fullname,
	birthdate,
	department
) values
	(5, 'fullname5', '25-09-1995', 'IT'),
	(6, 'fullname6', '30-09-1999', 'IT'),
	(7, 'fullname7', '25-09-1990', 'Fin'),
	(8, 'fullname8', '15-09-1997', 'Fin'),
	(9, 'fullname9', '25-09-1990', 'Fin'),
	(10, 'fullname10', '25-09-1991', 'Fin'),
	(11, 'fullname11', '22-09-1992', 'Fin'),
	(12, 'fullname12', '26-09-1993', 'Fin'),
	(13, 'fullname13', '25-09-1994', 'Fin'),
	(14, 'fullname14', '15-09-1995', 'Fin'),
	(15, 'fullname15', '24-09-1996', 'Fin'),
	(16, 'fullname16', '22-09-1996', 'Fin'),
	(17, 'fullname17', '25-05-1994', 'Fin'),
	(18, 'fullname18', '25-04-1997', 'Fin');


insert into record(
	employee_id,
	rdate,
	dayweek,
	rtime,
	rtype
) values
	(1, '20-12-2022', 'Понедельник', '09:01', 1),
	(1, '20-12-2022', 'Понедельник', '09:12', 2),
	(1, '20-12-2022', 'Понедельник', '09:40', 1),
	(1, '20-12-2022', 'Понедельник', '12:01', 2),
	(1, '20-12-2022', 'Понедельник', '13:40', 1),
	(1, '20-12-2022', 'Понедельник', '20:40', 2),

	(1, '21-12-2022', 'Понедельник', '09:01', 1),
	(1, '21-12-2022', 'Понедельник', '09:12', 2),
	(1, '21-12-2022', 'Понедельник', '09:40', 1),
	(1, '21-12-2022', 'Понедельник', '12:01', 2),
	(1, '21-12-2022', 'Понедельник', '13:40', 1),
	(1, '21-12-2022', 'Понедельник', '20:40', 2),

	(1, '22-12-2022', 'Понедельник', '09:01', 1),
	(1, '22-12-2022', 'Понедельник', '09:12', 2),
	(1, '22-12-2022', 'Понедельник', '09:40', 1),
	(1, '22-12-2022', 'Понедельник', '12:01', 2),
	(1, '22-12-2022', 'Понедельник', '13:40', 1),
	(1, '22-12-2022', 'Понедельник', '20:40', 2),


	(3, '21-12-2022', 'Понедельник', '09:01', 1),
	(3, '21-12-2022', 'Понедельник', '09:12', 2),
	(3, '21-12-2022', 'Понедельник', '09:40', 1),
	(3, '21-12-2022', 'Понедельник', '12:01', 2),
	(3, '21-12-2022', 'Понедельник', '13:40', 1),
	(3, '21-12-2022', 'Понедельник', '20:40', 2),

	(2, '21-12-2022', 'Понедельник', '08:51', 1),
	(2, '21-12-2022', 'Понедельник', '20:31', 2),

	(4, '21-12-2022', 'Понедельник', '09:51', 1),
	(4, '21-12-2022', 'Понедельник', '20:31', 2),

	(6, '21-12-2022', 'Понедельник', '09:51', 1),
	(6, '21-12-2022', 'Понедельник', '20:31', 2),

	(1, '23-12-2022', 'Среда', '09:11', 1),
	(1, '23-12-2022', 'Среда', '09:12', 2),
	(1, '23-12-2022', 'Среда', '09:40', 1),
	(1, '23-12-2022', 'Среда', '20:01', 2),

	(3, '23-12-2022', 'Среда', '09:01', 1),
	(3, '23-12-2022', 'Среда', '09:12', 2),
	(3, '23-12-2022', 'Среда', '09:50', 1),
	(3, '23-12-2022', 'Среда', '20:01', 2),

	(2, '23-12-2022', 'Среда', '08:41', 1),
	(2, '23-12-2022', 'Среда', '20:31', 2),

	(4, '23-12-2022', 'Среда', '09:51', 1),
	(4, '23-12-2022', 'Среда', '20:31', 2);

-- !!!1. Найти все отделы, в которых работает более 10 сотрудников
select department
from employee
group by department
having count(id) > 10;

-- !!!2. Найти сотрудников, которые не выходят с рабочего места
-- в течение всего рабочего дня
-- чет как-то
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

-- ну вроде норм
SELECT DISTINCT employee_id
FROM record r
WHERE rtype = 2
GROUP BY employee_id , rdate
HAVING COUNT(*) = 1; --с учетом ухода домой


-- Катя (мне кажется правильно проверять конец рабочего дня,
-- а что если он остался еще и выходил???)
select DISTINCT employee.fullname
from
(
select employee_id, rdate
from record
where rtype = 1 and rdate = '21-12-2022'
group by employee_id, rdate
having count(*) = 1
) as temp1 join
(
select employee_id, rdate
from record
where rtype = 2 and rtime >= '17:30:00'
group by employee_id, rdate
having count(*) = 1
) as temp2 on temp1.employee_id = temp2.employee_id
join employee on temp1.employee_id = employee.id


-- !!!3. Найти все отделы, в которых есть сотрудники, опоздавшие \
-- в определенную дату. Дату передавать с клавиатуры
select distinct department
from employee
where id in
(
	select employee_id
	from
	(
		select employee_id, min(rtime)
		from record
		where rtype = 1 and rdate = '23-12-2022'
		group by employee_id
		having min(rtime) > '9:00'
	) as tmp
);

-- Катя
select department
from
(
select *
from
(
select *, row_number() over(partition by employee_id, rdate order by rtime) as num
from record
where rtype = 1
)as temp_res1
where temp_res1.rtime > '09:00:00' and temp_res1.num = 1 and temp_res1.rdate = '21-12-2022'
)as temp_res2 join employee on temp_res2.employee_id = employee.id
group by department


-- !!!4. Отделы, в которых сотрудники опаздывают более 2х раз в неделю
--SELECT id, fullname, department
--FROM employee t1
---- И если существет таблица, показывающая
---- В какие недели работник опаздывал,
---- То выводим его отдел.
--WHERE EXISTS
--(
--    -- Внутренный запрос вернет таблицу, в которой
--    -- Первой столбец будет неделя (по счету, первая, вторя...)
--    -- А второй, кол-во опозданий сотрудника в этой недели.
--    -- Соотвтетственно, если опозданий нет, то таблица пуста.
    SELECT date_part, COUNT(employee_id) AS cnt, department
    FROM
    (
    	select employee_id, EXTRACT(WEEK FROM rdate) AS date_part
		from record r
		where rtype = 1
		group by employee_id, rdate
		having min(rtime) > '9:00'

    ) AS tmp join employee e on tmp.employee_id = e.id
    GROUP BY date_part, department
    HAVING COUNT(employee_id) > 2
--);


    ----------
select employee_id, rtime, --, min(rtime)
		from record
		where rtype = 1 and rdate = '23-12-2022'
		group by employee_id
		having min(rtime) > '9:00'

select *
from employee e join record r on e.id =r.employee_id



-- !!!5. Найти средний возраст сотрудников, не находящихся
-- на рабочем месте 8 часов в день.

-- Получиь возраст.
SELECT *, (CURRENT_DATE - e.birthdate) / 7 / 52  -- 7 - дней в неделе, 52 - недель в году.
FROM employee e;

SELECT *, e_v.rtime
FROM record e_v;

-- Алена
select avg(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate))
from employee join
	(
	select distinct on (employee_id, rdate) employee_id, rdate, sum(tmp_dur) over (partition by employee_id, rdate) as day_dur
	from
		(
		select employee_id, rdate, rtime,
			rtype,
			lag(rtime) over (partition by employee_id, rdate order by rtime) as prev_time,
			rtime-lag(rtime) over (partition by employee_id, rdate order by rtime) as tmp_dur
		from record r
		order by employee_id, rdate, rtime
		) as small_durations
	) as day_durations
on employee.id = day_durations.employee_id
where day_durations.day_dur < '11:00:00';

-- просто вывод с питона -- проверяла, что не так
SELECT AVG(2021 - Date_part('year', "t1"."birthdate"))
FROM (
	SELECT "t3"."employee_id", "t3"."rdate", sum(tmp_dur) OVER (PARTITION BY "t3"."employee_id", "t3"."rdate") AS "day_dur"
			FROM (
				SELECT employee_id, rdate, rtime, rtype,
						Lag("t2"."rtime") OVER (PARTITION BY "t2"."employee_id", "t2"."rdate") AS "prev_time",
						("t2"."rtime" - Lag("t2"."rtime") OVER (PARTITION BY "t2"."employee_id", "t2"."rdate")) AS "tmp_dur"
				FROM "record" AS "t2"
				ORDER BY "t2"."employee_id", "t2"."rdate", "t2"."rtime"
				) AS "t3"
	) AS "small_durations"
INNER JOIN "employee" AS "t1" ON ("t1"."id" = employee_id)
WHERE (day_dur < '11:00:00')

-- !!!6. Все отделы и кол-во сотрудников
-- Хоть раз опоздавших за всю историю учета.

select *
from employee e join record r on e.id =r.employee_id

--  пишет верный результат
-- но странно
SELECT table1.department, COUNT(distinct table1.id)
FROM employee AS table1
INNER JOIN record AS table2 ON (table2.employee_id = table1.id)
WHERE ((table2.rtime > '09:00:00') AND (table2.rtype = 1))
GROUP BY table1."department"


-- Алена
with first_time_in as (
	select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1)
select department, count(distinct first_time_in.employee_id)
from first_time_in join employee on first_time_in.employee_id = employee.id
where time_in > '09:00:00'
group by department;

-- без with
select department, count(distinct r.employee_id)
from
(select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1) as r join employee on r.employee_id = employee.id
where time_in > '09:00:00'
group by department;

-- !!!7. Найти самого старшего сотрудника в бухгалтерии
SELECT id, fullname, birthdate
FROM employee
WHERE department = 'IT' AND birthdate =
(SELECT MIN(birthdate)
FROM employee
WHERE department = 'IT'
);


-- !!!8. Найти сотрудников, выходивших больше 3-х раз с рабочего места
select e.id, e.fullname, cnt
from employee e join
	(SELECT DISTINCT employee_id, COUNT(*) as cnt
	FROM record
	WHERE rtype = 2
	GROUP BY employee_id, rdate
	HAVING COUNT(*) > 2) as tmp -- с учетом ухода домой
	on e.id = tmp.employee_id

-- !!!9. Найти сотрудника, который пришел сегодня последним
-- По схеме Алены
with first_time_in as (
	select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1)
select employee.id, employee.fullname, time_in
from first_time_in join employee on first_time_in.employee_id = employee.id
where rdate = '21-12-2022' and time_in = (select max(time_in)
				 from first_time_in
				 where rdate = '21-12-2022')


-- без wuth
select employee.id, employee.fullname, time_in
from
(select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1) as r join employee on r.employee_id = employee.id
where rdate = '21-12-2022' and time_in =
				(select max(time_in)
				 from (select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
						from record
						where rtype = 1) as ee
				 where rdate = '21-12-2022')


-- !!!10. Найти все отделы, в которых нет сотрудников моложе 25 лет
select DISTINCT department
from employee e
where department not in
(select DISTINCT department
from employee
where EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) < 25 )



-- !!!11. Найти сотружника, который пришел сегодня раньше всех на работу
with first_time_in as (
	select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1)
select employee.id, employee.fullname, time_in
from first_time_in join employee on first_time_in.employee_id = employee.id
where rdate = '23-12-2022' and time_in = (select min(time_in)
				 from first_time_in
				 where rdate = '23-12-2022')



-- !!!12. Найти сотрудников, опоздавших не менее 5-ти раз
with first_time_in as (
	select distinct on (employee_id , rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1 )
select id , count(first_time_in.employee_id)
from first_time_in join employee on first_time_in.employee_id = employee.id
where time_in > '09:00:00'
group by id
having count(first_time_in.employee_id) > 3;

-- без with
select id , fullname, count(first_time_in.employee_id)
from (select distinct on (employee_id , rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1 ) as first_time_in join employee on first_time_in.employee_id = employee.id
where time_in > '09:00:00'
group by id, fullname
having count(first_time_in.employee_id) > 3;



-- !!!13. Найти сотрудников, опоздавших сегодня меньше, чем на 5 минут
with first_time_in as (
	select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1)
select employee.id, employee.fullname, time_in
from first_time_in join employee on first_time_in.employee_id = employee.id
where rdate = '23-12-2022' and time_in <= '9:05' and time_in > '9:00'

-- без with
select employee.id, employee.fullname, time_in
from (select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1) as first_time_in join employee on first_time_in.employee_id = employee.id
where rdate = '23-12-2022' and time_in <= '9:05' and time_in > '9:00'



-- !!!14. Найти сотрудников, которые выходили больше, чем на 10 минут
select DISTINCT employee_id
from employee join
	(
	select employee_id, rdate, rtime,
			rtype,
			lag(rtime) over (partition by employee_id, rdate order by rtime) as prev_time,
			rtime-lag(rtime) over (partition by employee_id, rdate order by rtime) as tmp_dur
		from record r
		order by employee_id, rdate, rtime
		) as small_durations
on employee.id = small_durations.employee_id
where small_durations.rdate = '21-12-2022'
and small_durations.tmp_dur > '00:10:00'
group by small_durations.employee_id
HAVING count(small_durations.employee_id) > 1


-- !!!15.Найти сотрудников бухгалтерии, приходивших на работу раньше 8-00
with first_time_in as (
	select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1)
select employee.id, employee.fullname, time_in
from first_time_in join employee on first_time_in.employee_id = employee.id
where employee.department = 'IT' and time_in <= '9:00'

-- без with
select DISTINCT  on (employee.id, employee.fullname) employee.id, employee.fullname
from (select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1) as first_time_in join employee on first_time_in.employee_id = employee.id
where employee.department = 'IT' and time_in <= '9:00'


-- !!!16. Найти департ, в которых работает от 6 до 15 сотрудников в возрасте 26 лет
select department
from employee e
where EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) = 25 -- типа возраст 26
group by department
HAVING count(*) >= 2 -- типа от 6 до 15


--#########################################################################
-- задание 1

-- !!!1. Написать табличную функцию, возвращающую сотрудников, не пришедших сегодня на
-- работу. «Сегодня» необходимо вводить в качестве параметра.

create extension plpython3u;

CREATE TABLE table1
(
    id INT,
    fullname VARCHAR,
    department VARCHAR
)
WITH (
  OIDS = FALSE,
  autovacuum_enabled = true
);

CREATE OR REPLACE FUNCTION missed_work(dt DATE) -- dt - "сегодня"
RETURNS setof table1
AS $$
	plan = plpy.prepare("\
	    SELECT id, fullname, department\
	    FROM employee\
	    WHERE id NOT IN\
	    (\
	        SELECT employee.id\
	        FROM employee JOIN record ea on employee.id = ea.employee_id\
	        WHERE rdate = $1\
	        AND rtype = 1);", ["DATE"])
	run = plpy.execute(plan, [dt])
	return run
$$LANGUAGE plpython3u;

SELECT * FROM missed_work('21-12-2022');

    SELECT id, fullname, department
    FROM employee
    WHERE id NOT IN
    (
        SELECT employee.id
        FROM employee JOIN record ea on employee.id = ea.employee_id
        WHERE rdate = '21-12-2022'--dt
        AND rtype = 1
    );

-- !!!2. Написать скалярную функцию, возвращающую количество сотрудников
-- в возрасте от 18 до 40, выходивших более 3х раз.


-------------------------------------------------------------------------------- версия Алены (странно писать о себе в 3 лице...)
-- сама функция, пояснения ниже (от мелких запросов к основному)
drop function if exists task2();
CREATE OR REPLACE FUNCTION task2()
RETURNS real
AS $$
plan = plpy.prepare("""
select id, fullname
from employee
where id in (
	with help_row_numbers as (
		select employee_id, rdate, rtime, rtype, row_number() over (partition by employee_id, rdate, rtype order by rtime) as r1
		from record
		order by employee_id, rdate, rtime, rtype)
	select employee_id
	from help_row_numbers
	where rtype = 2
	group by employee_id
	having max(r1) > 2 )
and EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) between 18 and 40;""")

res = plpy.execute(plan)

return res.nrows()

$$ LANGUAGE plpython3u;

SELECT * FROM task2();

--- так сможем посчитать количество выходов - это
--  максиммальный row_number по r_type=2  для каждого сотрудника в течении дня
select employee_id, rdate, rtime, rtype, row_number() over (partition by employee_id, rdate, rtype order by rtime) as r1
from record
order by employee_id, rdate, rtime, rtype;


-- нам все-равно, в какой именно день он там курил постоянно, поэтому просто макс смотрим
with help_row_numbers as (
	select employee_id, rdate, rtime, rtype, row_number() over (partition by employee_id, rdate, rtype order by rtime) as r1
	from record
	order by employee_id, rdate, rtime, rtype)
select employee_id, max(r1) as max_leaves
from help_row_numbers
where rtype = 2
group by employee_id
having max(r1) > 2;

-- осталось взять id и по нему средний возраст
select id, fullname
from employee
where id in (
	with help_row_numbers as (
		select employee_id, rdate, rtime, rtype, row_number() over (partition by employee_id, rdate, rtype order by rtime) as r1
		from record
		order by employee_id, rdate, rtime, rtype)
	select employee_id
	from help_row_numbers
	where rtype = 2
	group by employee_id
	having max(r1) > 2 )
and EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) between 18 and 40;
----------------------------------------------------------------------------------------------конец


-- теперь все норм (на всякий проверка на дату)
CREATE OR REPLACE FUNCTION count_employee(dt DATE)
RETURNS INT
AS
$$
	plan = plpy.prepare("\
			SELECT employee.id, COUNT(employee.id)\
			FROM employee JOIN record ea on employee.id = ea.employee_id\
			WHERE date_part('year', age(birthdate)) > 18\
			AND date_part('year', age(birthdate)) < 40\
			AND ea.rtype = 1\
			AND ea.rdate = $1\
			GROUP BY employee.id\
			having count(employee.id) >= 3;", ["DATE"])
	run = plpy.execute(plan, [dt])

	return run.nrows()
$$ LANGUAGE plpython3u;

SELECT * FROM count_employee('21-12-2022') AS cnt;

-- но тут мы продолжаем биться (ошибка связана с пробелами/табами)
create or replace function latters_cnt(target_date date)
returns int
as $$
	run = plpy.execute(f"\
		select distinct id \
		from employee\
		where EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) BETWEEN 18 and 40 and \
		id in(\
		select employee_id\
		from(\
			select employee_id, rdate, rtype, count(*)\
			from record\
			where rdate = {target_date}\
			group by employee_id, rdate, rtype\
			having rtype = 2 and count(*) >= 3\
		) as tmp0);")
	return run.nrows()
END;
$$ language plpython3u;

-- !!!3.Написать скалярную функцию, возвращающую минимальный
-- Возраст сотрудника, опоздавшего более чем на 10 минут.
-- Минимальный возраст == максимальная дата рождения.
-------------------------------------------------------------------------------- версия Алены (все еще странно)
-- та норм же вроде.....
drop function if exists task3();
CREATE OR REPLACE FUNCTION task3()
RETURNS real
AS $$
plan = plpy.prepare("""
select min(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate)) as min_age
from employee
where id in (
	with help_row_numbers as (
			select employee_id, rdate, rtime, rtype, row_number() over (partition by employee_id, rdate, rtype order by rtime) as r1
			from record
			order by employee_id, rdate, rtime, rtype)
		select employee_id
		from help_row_numbers
		where rtype = 1 and r1 = 1
		group by employee_id
		having max(rtime) - '09:00:00' > '00:10:00');""")

res = plpy.execute(plan)

if res:
	return res[0]['min_age']

$$ LANGUAGE plpython3u;

SELECT * FROM task3() as "min_age";

select min(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate)) as min_age
from employee
where id in (
	with help_row_numbers as (
			select employee_id, rdate, rtime, rtype, row_number() over (partition by employee_id, rdate, rtype order by rtime) as r1
			from record
			order by employee_id, rdate, rtime, rtype)
		select employee_id
		from help_row_numbers
		where rtype = 1 and r1 = 1
		group by employee_id
		having max(rtime) - '09:00:00' > '00:10:00');
--------------------------------------------------------------------------- конец

-- запрос верный, но в функции твориться какая-то ерунда, возврат 31, когда запрос 24 и 22
CREATE OR REPLACE FUNCTION get_latecomer()
RETURNS INT
AS $$
	res = plpy.execute(f"\
		SELECT max(date_part('year', age(birthdate))) as m\
	    FROM employee JOIN record ea on employee.id = ea.employee_id\
	    WHERE ea.rtype = 1 --AND ea.rtime > '09:10:00'\
	    group by id \
	    having min(ea.rtime) > '9:10'\
		order by m desc;")
	plpy.notice(res)
	return res[0]['m']
$$LANGUAGE plpython3u;

drop function get_latecomer()
SELECT * FROM get_latecomer();

SELECT max(date_part('year', age(birthdate))) as m
FROM employee JOIN record ea on employee.id = ea.employee_id
WHERE ea.rtype = 1 --AND ea.rtime > '09:10:00'
group by id
having min(ea.rtime) > '9:10'
order by m desc


-- !!!4. департамент с минимальным кол-вои сотрудников
-- просто нашла где-то)))))
-- вроде правильно
CREATE OR REPLACE FUNCTION Min_Count()
RETURNS VARCHAR(20) AS $$
	res = plpy.execute("select test.department\
   		 				from (\
				        select distinct e.department, min(count(e.id)) over (partition by e.id) as total\
				        from record r join employee e on r.employee_id = e.id\
				        group by e.department, e.id) as test\
				        order by total limit 1;")
	return res[0]['department']
$$ LANGUAGE 'plpython3u' VOLATILE;
select Min_Count();

select test.department
from (
select distinct e.department, min(count(e.id)) over (partition by e.id) as total
from record r join employee e on r.employee_id = e.id
group by e.department, e.id) as test
order by total limit 1;



-- !!!5. Написать табличную функцию, возвращающую статистику
-- на сколько и кто опоздал в
-- определенную дату. Дату вводить с клавиатуры.
select mt, count(mt)
from (
	select  (min(rtime) - '9:00') as mt
	from record r
	where rdate = '21-12-2022' and rtype = 1
	group by employee_id
	having min(r.rtime) > '9:00') as t1
group by mt


CREATE table res_test
(
    mt  time,
    cnt int
)
WITH (
  OIDS = FALSE,
  autovacuum_enabled = true
);

drop table res_test

CREATE OR REPLACE FUNCTION let_emp()
RETURNS setof res_test
AS $$
	res = plpy.execute("select mt, count(mt) as cnt\
   		 				from (\
				        select  (min(rtime) - '9:00') as mt\
				        from record r\
				        where rdate = '21-12-2022' and rtype = 1\
				        group by employee_id\
				        having min(r.rtime) > '9:00') as t1\
						group by mt;")
	return res
$$ LANGUAGE 'plpython3u' VOLATILE;

select * from let_emp();


-- 6. -- Кол-во опоздавших сотрудников.
-- Дата опоздания в кач-ве параметра.

-- надо подумать, делала давно
CREATE OR REPLACE FUNCTION get_latecomers(dt DATE)
RETURNS INT
AS
$$
    SELECT COUNT(employee_id) AS cnt
    FROM record
    WHERE rdate = dt
    AND rtime > '09:00:00'
    AND rtype = 1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_latecomers2(dt DATE)
RETURNS INT
AS $$
count_ = 0
plan = plpy.prepare("select employee.id, employee.fullname, time_in, rdate\
				from (select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in\
				from record\
				where rtype = 1) as first_time_in \
				join employee on first_time_in.employee_id = employee.id\
				where time_in > '9:00' and rdate = $1;", ["DATE"])

run = plpy.execute(plan, [dt])
count_ = run.nrows()
return count_
$$ LANGUAGE plpython3u;


SELECT get_latecomers2('2022-12-21') AS cnt;


select employee.id, employee.fullname, time_in, rdate
from (select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
	from record
	where rtype = 1) as first_time_in
join employee on first_time_in.employee_id = employee.id
where time_in > '9:00' and rdate = '21-12-2022'