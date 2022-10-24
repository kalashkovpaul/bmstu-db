-- 1. Скалярная функция

create or replace function get_avg_hobbits_height()
returns float as '
	select avg(height) from hobbits;
' language sql;

select get_avg_hobbits_height() as avg_height;

-- 2. Подставляемая табличная функция

create or replace function get_dwarf(d_id int = 0)
returns dwarfs as '
	select *
	from dwarfs
	where id = d_id;
' language sql;

select *
from get_dwarf(123);

-- 3. Многооператорная табличная функция

create or replace function get_tall_or_experienced_hobbits(reqHeight int, battleYearsAgo int)
returns table (hobbit_id int, hobbit_height int)
as '
	begin
		return query
		select h.id, h.height
		from hobbits as h
		where h.height > reqHeight;

		return query
		select distinct h.id, h.height
		from hobbits as h
		join hob on h.id = hob.hobid
		join battles on hob.bid = battles.id
		where battles.yearsago > battleYearsAgo and h.height < reqHeight;
	end;
' language plpgsql;

select * from get_tall_or_experienced_hobbits(80, 500);

-- 4. Рекурсивная функция или функция с рекурсивным ОТВ

create or replace function get_skilled(reqSkill varchar, reqSkilllevel int)
returns table (id int, name varchar, skill varchar, height int, skilllevel int) as
'
	with recursive dwarfshierarchy(id, name, skill, height, skilllevel) as
	(
		select distinct on (d1.skill) d2.id, d2.name, d1.skill, d1.height, 1 as skilllevel
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
		select distinct on (d3.id) d3.id, d3.name, d3.skill, d3.height, d4.skilllevel + 1
		from dwarfs as d3 join dwarfshierarchy as d4 on d3.skill = d4.skill
		where d4.height - d3.height = 10
	)
	select *
	from dwarfshierarchy as d5
	where d5.skill = reqSkill and d5.skilllevel = reqSkilllevel;
' language sql;

select * from get_skilled('Advocate', 2);

-- 5. Хранимая процедура без параметров или с параметрами

create or replace procedure insert_orc(
	id int,
	name varchar,
	master varchar,
	danger int,
	endurance int,
	bravery int
) as '
begin
	insert into orcs
	values(id, name, master, danger, endurance, bravery);
end;
' language plpgsql;

call insert_orc(5555, 'Perfect Orc', 'Sauron', 9, 9, 9);

select * from orcs where id = 5555

-- 6. Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ

CREATE OR REPLACE PROCEDURE fib_proc
(
    res INOUT INT,
    max INT,
    first INT DEFAULT 1,
    second INT DEFAULT  1
)
AS '
DECLARE
    tmp INT;
BEGIN
    tmp = first + second;
    IF tmp <= max THEN
        res = tmp;
        CALL fib_proc(res, max, second, tmp);
    END IF;
END;
'LANGUAGE  plpgsql;

CALL fib_proc(0, 200);

-- 7. Хранимая процедура с курсором

select *
into orcs_tmp_cursor
from orcs;

create or replace procedure proc_update_cursor
(
    old_master varchar,
    new_master varchar
)
as '
declare
    myCursor cursor for
        select *
        from orcs_tmp_cursor
        where master = old_master;
    tmp orcs_tmp_cursor;
begin
    open myCursor;
    loop
        -- fetch - Получает следующую строку из курсора
        -- И присваевает в переменную, которая стоит после INTO.
        -- Если строка не найдена (конец), то присваевается значение NULL.
        fetch myCursor
        into tmp;
        -- Выходим из цикла, если нет больше строк (Т.е. конец).
        exit when not found;
        update orcs_tmp_cursor
        set master = new_master
        where orcs_tmp_cursor.id = tmp.id;
        raise notice ''%'', tmp;
    end loop;
    close myCursor;
end;
'language  plpgsql;

call proc_update_cursor('Saurony', 'Sauron');

select * from orcs_tmp_cursor;

-- 8. Хранимая процедура доступа к метаданным https://postgrespro.ru/docs/postgresql/9.6/infoschema-columns

create or replace procedure get_metadata(name varchar)
as '
   	declare
        myCursor cursor for
            select column_name,
                   data_type
            from information_schema.columns
            where table_name = name;
            tmp record; -- record - переменная, которая подстравивается под любой тип.
	begin
        open myCursor;
        loop
            fetch myCursor
            into tmp;
            exit when not found;
            raise notice ''column name = %; data type = %'', tmp.column_name, tmp.data_type;
        end loop;
        close myCursor;
	end;
' language plpgsql;

call get_metadata('hobbits');

-- 9. Триггер AFTER

select * into hobbits_tmp
from hobbits;

select * from hobbits

create or replace function update_trigger()
returns trigger as '
	begin
		raise notice ''New =  %'', new;
		raise notice ''Old =  %'', old;
		update hobbits_tmp
		set weight = old.weight + 1
		where id = old.id and old.height <> new.height;
		return new;
	end;
' language plpgsql;

create trigger log_update
after update on hobbits_tmp
for each row
execute procedure update_trigger();

select * from hobbits_tmp where name = 'Merry' and surname = 'Brandybuck';

update hobbits_tmp
set height = height + 1
where name = 'Merry' and surname = 'Brandybuck';

-- 10. Триггер INSTEAD OF

create view humans_tmp1 as
select * from humans;

drop view humans_tmp1;

create or replace function del_human_function()
returns trigger
as '
	begin
		raise notice ''New =  %'', new;
		raise notice ''Old =  %'', old;

		update humans_tmp1
		set age = -1
		where id = old.id;

		return new;
	end;
' language plpgsql;

create trigger del_human_trigger
instead of delete on humans_tmp1
for each row
execute procedure del_human_function();

select * from humans_tmp1 where id = 334;

select *  from hub where humid = 334;

delete from humans_tmp1 where id = 334;



