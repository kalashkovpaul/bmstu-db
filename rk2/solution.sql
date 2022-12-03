create database rk2;

--- in rk2
create table if not exists excursions (
	id int not null primary key,
	name varchar(50) default 'Excursion',
	description varchar(100) default 'Description',
	open_date date default '1900-01-01',
	close_date date default '1900-01-01'
);

create table if not exists stands (
	id int not null primary key,
	name varchar(50) default 'Stand',
	field varchar(20) default 'Field',
	short_desc varchar(50) default 'Short description'
);

create table if not exists visitors (
	id int not null primary key,
	full_name varchar(50) default 'Full name',
	address varchar(50) default 'Address',
	phone_number varchar(20) default 'Phone number'
);

--- Таблицы связки
create table if not exists es (
	eid int not null,
	sid int not null,
	foreign key (eid) references excursions(id),
	foreign key (sid) references stands(id)
);

create table if not exists ev (
	eid int not null,
	vid int not null,
	foreign key (eid) references excursions(id),
	foreign key (vid) references visitors(id)
);

insert into excursions values (1, 'To Kremlin', 'See Kremlin', '2022-11-26', '2022-11-27');
insert into excursions values (2, 'To BMSTU', 'See BMSTU', '2022-10-26', '2022-10-27');
insert into excursions values (3, 'To MSU', 'See MSU', '2022-09-26', '2022-09-27');
insert into excursions values (4, 'To HSE', 'See HSE', '2022-08-26', '2022-08-27');
insert into excursions values (5, 'To Gorky Park', 'See Gorky Park', '2022-11-26', '2022-11-27');
insert into excursions values (6, 'To Arbat', 'See Arbat', '2022-11-26', '2022-11-27');
insert into excursions values (7, 'To a', 'See a', '2022-11-26', '2022-11-27');
insert into excursions values (8, 'To b', 'See b', '2022-11-26', '2022-11-27');
insert into excursions values (9, 'To c', 'See c', '2022-11-26', '2022-11-27');
insert into excursions values (10, 'To d', 'See d', '2022-11-26', '2022-11-27');
insert into excursions values (11, 'To e', 'See e', '2022-11-26', '2022-11-27');
insert into excursions values (12, 'To f', 'See f', '2022-11-26', '2022-11-27');

insert into stands values (1, 'Kremlin', 'Moscow', 'This is Kremlin');
insert into stands values (2, 'BMSTU', 'Basmannaya', 'This is BMSTU');
insert into stands values (3, 'MSU', 'Vorobyovi Gori', 'This is MSU');
insert into stands values (4, 'HSE', 'Kurskaya', 'This is HSE');
insert into stands values (5, 'Gorky Park', 'Moscow', 'This is Gorky Park');
insert into stands values (6, 'Arbat', 'Moscow', 'This is Arbat');
insert into stands values (7, 'a', 'Alphabet', 'This is a');
insert into stands values (8, 'b', 'Alphabet', 'This is b');
insert into stands values (9, 'c', 'Alphabet', 'This is c');
insert into stands values (10, 'd', 'Alphabet', 'This is d');
insert into stands values (11, 'e', 'Alphabet', 'This is e');
insert into stands values (12, 'f', 'Alphabet', 'This is f');

insert into visitors values(1, 'abc', 'alphabet', '1-234-567-89-01');
insert into visitors values(2, 'bcd', 'alphabet', '1-234-567-89-02');
insert into visitors values(3, 'cde', 'alphabet', '1-234-567-89-03');
insert into visitors values(4, 'def', 'alphabet', '1-234-567-89-04');
insert into visitors values(5, '123', 'numbers', '1-234-567-89-05');
insert into visitors values(6, '234', 'numbers', '1-234-567-89-06');
insert into visitors values(7, '345', 'numbers', '1-234-567-89-07');
insert into visitors values(8, '!@#', 'special', '1-234-567-89-08');
insert into visitors values(9, '@#$', 'special', '1-234-567-89-09');
insert into visitors values(10, '#$%', 'special', '1-234-567-89-10');
insert into visitors values(11, '*()', 'special', '1-234-567-89-11');

insert into es values (1, 1);
insert into es values (2, 2);
insert into es values (3, 3);
insert into es values (4, 4);
insert into es values (5, 5);
insert into es values (6, 6);
insert into es values (7, 7);
insert into es values (11, 8);
insert into es values (10, 9);
insert into es values (9, 10);
insert into es values (8, 11);

insert into ev values (1, 1);
insert into ev values (2, 2);
insert into ev values (3, 3);
insert into ev values (4, 4);
insert into ev values (5, 5);
insert into ev values (6, 6);
insert into ev values (7, 7);
insert into ev values (11, 8);
insert into ev values (10, 9);
insert into ev values (9, 10);
insert into ev values (8, 11);

