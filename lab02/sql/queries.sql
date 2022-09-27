-- 1. Инструкция SELECT, использующая предикат сравнения.
SELECT d.name
FROM dwarfs AS d
WHERE d.age = 350;

-- 2. Инструкция SELECT, использующая предикат BETWEEN.
SELECT h.name, h.surname
FROM hobbits AS h
WHERE h.residence = 'Shire' AND h.age BETWEEN 33 AND 50;

-- 3. Инструкция SELECT, использующая предикат LIKE.
SELECT o.name, o.master
FROM orcs AS o
WHERE o.name LIKE 'A%g';

-- 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
SELECT h.id, h.name, h.skill
FROM humans AS h
WHERE h.id IN (
	SELECT humid
	FROM hub
	WHERE bid = 1);
	
-- 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
SELECT d.id, d.name
FROM dwarfs AS d
WHERE EXISTS (SELECT battles.id FROM battles
			   JOIN "db" 
			   ON "db".bid = battles.id AND d.id = "db".did
			   AND battles.duration > 3600);
			   
-- 6. Инструкция SELECT, использующая предикат сравнения с квантором.
SELECT d.id, d.name, d.height
FROM dwarfs AS d
WHERE d.height >= ALL(SELECT height FROM dwarfs);

-- 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
SELECT AVG(height) AS "avg height", SUM(age) / COUNT(age) AS "avg age"
FROM hobbits;

-- 8. Инструкция  SELECT, использующая скалярные подзапросы в выражениях столбцов.
SELECT h.id, h.name, h.surname,
	(SELECT AVG(duration) FROM
		battles JOIN hob ON battles.id = hob.bid AND hob.hobid = h.id) 
		AS "avg duration"
FROM hobbits as h;

-- 9. Инструкция SELECT, использующая простое выражение CASE.
SELECT d.id, d.name, d.height, d.skill,
	CASE
		WHEN d.height > 100 THEN 'tall'
		WHEN d.height > 80 THEN 'average'
		WHEN d.height > 60 THEN 'short'
		ELSE 'very short'
	END AS "height meaning"
FROM dwarfs AS d;

-- 10. Инструкция SELECT, использующая поисковое выражение CASE. 
SELECT d.id, d.name, d.height, d.beird
FROM dwarfs AS d
ORDER BY
(CASE
	WHEN d.height > 100 THEN d.beird
	ELSE 0
 END) DESC;
