CREATE TABLE IF NOT EXISTS db
(
    did INT NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY (did) REFERENCES dwarfs(id),
    FOREIGN KEY (bid) REFERENCES battles(id)
);

-- \COPY db FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab02/csv/dwarfBattles.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS hob
(
    hobid INT NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY (hobid) REFERENCES hobbits(id),
    FOREIGN KEY (bid) REFERENCES battles(id)
);

-- \COPY hob FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab02/csv/hobbitBattles.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS hub
(
    humid INT NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY (humid) REFERENCES humans(id),
    FOREIGN KEY (bid) REFERENCES battles(id)
);

-- \COPY hub FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab02/csv/humanBattles.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS ob
(
    "oid" INT NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY ("oid") REFERENCES orcs(id),
    FOREIGN KEY (bid) REFERENCES battles(id)
);

-- \COPY ob FROM '/Users/p.kalashkov/Desktop/fifthTerm/bmstu-db/lab02/csv/orcBattles.csv' delimiter ',';