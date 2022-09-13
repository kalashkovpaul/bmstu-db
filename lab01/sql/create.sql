CREATE TABLE IF NOT EXISTS battles
(
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(50) DEFAULT 'Lost',
    place VARCHAR(20) DEFAULT 'Lost Lands',
    yearsAgo INT CHECK (yearsAgo > 0 AND yearsAgo < 8001),
    reason VARCHAR(20) DEFAULT 'Lost',
    duration INT NOT NULL
);

-- \COPY battles FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab01/csv/battles.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS hobbits
(
    id INT NOT NULL PRIMARY KEY,
    "name" VARCHAR(20) DEFAULT 'Lost',
    surname VARCHAR(20) DEFAULT 'Lost',
    residence VARCHAR(20) DEFAULT 'Lost',
    class VARCHAR(20) DEFAULT 'Lost',
    height INT NOT NULL CHECK (height > 0 AND height < 100),
    "weight" INT NOT NULL CHECK ("weight" > 0 AND "weight" < 40),
    age INT NOT NULL CHECK (age > 0 AND age < 94),
    gender VARCHAR(6) CHECK (gender = 'Male' OR gender = 'Female'),
    adventure INT NOT NULL CHECK (adventure >= 1 AND adventure <= 10)
);

-- \COPY hobbits FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab01/csv/hobbits.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS humans
(
    id INT NOT NULL PRIMARY KEY,
    "name" VARCHAR(20) DEFAULT 'Lost',
    gender VARCHAR(6) CHECK (gender = 'Male' OR gender = 'Female'),
    age INT NOT NULL CHECK (age > 0 AND age < 94),
    country VARCHAR(20) DEFAULT 'Lost',
    skill VARCHAR(20) DEFAULT 'Lost',
    purpose VARCHAR(20) DEFAULT 'Lost'
);

-- \COPY humans FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab01/csv/humans.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS orcs
(
    id INT NOT NULL PRIMARY KEY,
    "name" VARCHAR(20) DEFAULT 'Lost',
    "master" VARCHAR(20) DEFAULT 'Lost',
    danger INT NOT NULL CHECK (danger >= 1 AND danger <= 10),
    endurance INT NOT NULL CHECK (endurance >= 1 AND endurance <= 10),
    bravery INT NOT NULL CHECK (bravery >= 1 AND bravery <= 10)
);

-- \COPY orcs FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab01/csv/orcs.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS dwarfs
(
    id INT NOT NULL PRIMARY KEY,
    "name" VARCHAR(20) DEFAULT 'Lost',
    gender VARCHAR(20) DEFAULT 'Lost',
    height INT NOT NULL CHECK (height >= 1 AND height <= 120),
    beird INT NOT NULL CHECK (beird >= 1 AND beird <= 50),
    skill VARCHAR(20) DEFAULT 'Lost',
    "weight" INT NOT NULL CHECK ("weight" > 0 AND "weight" < 70),
    age INT NOT NULL CHECK (age > 0 AND age < 400)
);

ALTER TABLE dwarfs
ALTER COLUMN "name" TYPE VARCHAR(20);

-- \COPY dwarfs FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab01/csv/dwarfs.csv' delimiter ',';