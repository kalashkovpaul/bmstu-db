create table if not exists employee
(
	id int not null,
	fullname varchar(30),
	dt date,
	status varchar(30)
);

drop table employee;

set datestyle to European;

insert into employee values
	(1, 'Иванов Иван Иванович', '12-12-2022', 'Работа offline'),
	(1, 'Иванов Иван Иванович', '13-12-2022', 'Работа offline'),
	(1, 'Иванов Иван Иванович', '14-12-2022', 'Больничный'),
	(1, 'Иванов Иван Иванович', '15-12-2022', 'Больничный'),
	(1, 'Иванов Иван Иванович', '16-12-2022', 'Удаленная работа'),
	(2, 'Петров Петр Петрович', '12-12-2022', 'Работа offline'),
	(2, 'Петров Петр Петрович', '13-12-2022', 'Работа offline'),
	(2, 'Петров Петр Петрович', '14-12-2022', 'Удаленная работа'),
	(2, 'Петров Петр Петрович', '15-12-2022', 'Удаленная работа'),
	(2, 'Петров Петр Петрович', '16-12-2022', 'Работа offline');

create extension plpythonu;

create or replace function get_interval()
returns table
(
	id int,
	fullname varchar(30),
	date_from date,
	date_to date,
	status varchar(30)
) as $$
	tmp = plpy.execute(f"select id, fullname, dt as date_from,  dt as date_to, status from employee")
	res = []
	cur_status = tmp[0]["status"]
	cur_fullname = tmp[0]["fullname"]
	res.append(tmp[0])

	for i in range (len(tmp)):
		if tmp[i]["status"] != cur_status or tmp[i]["fullname"] != cur_fullname:
			res[-1]["date_to"] = tmp[i - 1]["date_from"]
			res.append(tmp[i])
			cur_status = tmp[i]["status"]
			cur_fullname = tmp[i]["fullname"]

	res[-1]["date_to"] = tmp[-1]["date_from"]
	return res
$$ language plpython3u;
	