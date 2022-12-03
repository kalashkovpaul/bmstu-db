import { db } from "./db.js";

export async function query1(dwarfname) {
    try {
        const dwarfs = await db.many({
            text: 'SELECT * FROM dwarfs WHERE name = $1',
            values: [dwarfname]
        });
        console.log("Информация о дварфах с именем ", dwarfname);
        console.log();
        if (dwarfs.length === 0) {
            console.log("Дварфов с таким именем ещё не родилось, подождите хоть 300 лет");
        } else {
            dwarfs.forEach(dwarf => {
                console.log("ID дварфа: ", dwarf.id);
                console.log("Имя дварфа: ", dwarf.name);
                console.log("Пол дварфа: ", dwarf.gender);
                console.log("Рост дварфа: ", dwarf.height);
                console.log("Длина бороды дварфа: ", dwarf.beird);
                console.log("Профессия дварфа: ", dwarf.skill);
                console.log("Вес дварфа: ", dwarf.weight);
                console.log("Возраст дварфа: ", dwarf.age);
                console.log();
            });
        }
    } catch {
        console.log("Дварфов с таким именем ещё не родилось, подождите хоть 300 лет");
    }
}

export async function query2() {
    try {
        const dwarfsierarchy = await db.many({
            text: 'with recursive dwarfshierarchy(id, name, skill, height, skilllevel) as \
            (\
                select distinct on (d1.skill) d2.id, d2.name, d1.skill, d1.height, 1 as skilllevel \
                from \
                ( \
                    (select d.skill, max(height) as height \
                    from dwarfs as d \
                    group by d.skill) as d1 \
                    \
                    inner join \
                    (select d.id, d.skill, d.height, d.name \
                    from dwarfs as d) as d2 \
                    on (d1.skill = d2.skill and d1.height = d2.height)\
                ) \
                \
                union all \
                select distinct on (d3.id) d3.id, d3.name, d3.skill, d3.height, d4.skilllevel + 1 \
                from dwarfs as d3 join dwarfshierarchy as d4 on d3.skill = d4.skill \
                where d4.height - d3.height = 10 \
            ) \
            select * from dwarfshierarchy'
        });
        let i = 0;
        dwarfsierarchy.forEach((dwarf) => {
            console.log(`${i}. Имя: ${dwarf.name}, профессия: ${dwarf.skill}, уровень: ${dwarf.skilllevel}`);
            i++;
        })
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query3() {
    try {
        const avg = await db.many({
            'text': 'with tallHobbits(name, surname, residence, height) as (\
                select h.name, h.surname, h.residence, h.height \
                from hobbits as h \
                where h.height > 80 \
            ) \
            select avg(th.height) as "avg" \
            from tallHobbits as th'
        });
        console.log("Средний рост хоббитов выше 80 дюймов равен", avg[0].avg);
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query4() {
    try {
        const columns = await db.many({
            'text': "select column_name, data_type from information_schema.columns \
            where data_type = 'integer'"
        });
        columns.forEach((column) => {
            console.log(`Название колонки: ${column.column_name}, тип: ${column.data_type}`);
        });
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query5() {
    try {
        const avg = await db.one({
            'text': 'select get_avg_hobbits_height() as avg_height;'
        });
        console.log(`Средний рост хоббитов: ${avg.avg_height} дюймов`);
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query6() {
    try {
        const hobbits = await db.many({
            'text': 'select * from get_tall_or_experienced_hobbits(120, 7900);'
        });
        hobbits.forEach((hobbit) => {
            console.log(`ID хоббита: ${hobbit.hobbit_id}, его рост: ${hobbit.hobbit_height} дюймов`);
        });
        console.log();
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query7() {
    try {
        await db.none({
            'text': `call insert_orc(5555, 'Mighty Orc', 'Sauron', 9, 9, 9);`
        });
        console.log("Могучий орк добавлен!")
    } catch {
        console.log("Такой орк уже существует, может быть только один могучий орк!");
    }
}

export async function query7_1() {
    try {
        await db.none({
            'text': "delete from orcs where name = 'Mighty Orc';"
        });
        console.log("Никогда мир не увидит такого могучего орка...");
    } catch {
        console.log("Что-то пошло не так, могучего орка не так просто удалить!");
    }
}

export async function query8() {
    try {
        const info = await db.one({
            'text': "select current_database(), current_user;"
        });
        console.log(`Название текущей базы данных: ${info.current_database}, а Вы - ${info.current_user}`);
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query9() {
    try {
        await db.none({
            'text': "create table if not exists nazguls (\
                id INT NOT NULL PRIMARY KEY,\
                name VARCHAR(20) DEFAULT 'Theo',\
                kind VARCHAR(20) DEFAULT 'Human',\
                master VARCHAR(20) DEFAULT 'Sauron');",
        });
        console.log("Таблица назгулов создана!");
    } catch {
        console.log("Что-то пошло не так");
    }
}

export async function query10(name, kind, master) {
    try {
        const amount = await db.one({
            text: 'select count(*) from nazguls;'
        });
        const id = amount.count + 1;
        await db.none ({
            text: "insert into nazguls values ($1, $2, $3, $4);",
            values: [id, name, kind, master]
        });
        console.log(`Назгул по имени ${name} добавлен!`);
    } catch (e) {
        if (e.routine === 'parserOpenTable') {
            console.log(e.message);
        } else {
            console.log("Что-то пошло не так");
        }
        console.log(e.constructor.name);
    }
}