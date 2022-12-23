-- Доп. задача 1

create table if not exists Table1
(
	id int,
	var1 char,
	date_from date,
	date_to date
);

create table if not exists Table2
(
    id int,
	var2 char,
	date_from date,
	date_to date
);

delete from table1

insert into Table1 values (1, 'A', '2022-10-01', '2022-10-17');
insert into Table1 values (1, 'B', '2022-10-18', '5999-12-31');

insert into Table2 values (1, 'A', '2022-10-01', '2022-10-18');
insert into Table2 values (1, 'B', '2022-10-19', '5999-12-31');
insert into Table2 values (2, 'B', '2022-10-01', '5999-12-31');

select * from Table1;
select * from Table2;

select coalesce(t1.id, t2.id) as id, t1.var1, t2.var2,
		case
			when t1.date_from >= t2.date_from
				then t1.date_from
				else t2.date_from
		end,
		case
			when t1.date_to <= t2.date_to
				then t1.date_to
				else t2.date_to
		end
--select t1.*, t2.*
from Table1 t1 full join Table2 t2 on t1.id = t2.id
where t1.date_from <= t2.date_to
	  and t2.date_from <= t1.date_to
	  or var1 is null or var2 is null
