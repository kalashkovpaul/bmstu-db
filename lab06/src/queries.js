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