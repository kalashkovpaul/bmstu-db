import { menuMessage } from './consts.js';
import * as readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'process';
import { query1, query10, query2, query3, query4, query5, query6, query7, query7_1, query8, query9 } from './queries.js';

const rl = readline.createInterface({ input, output });

export async function menu() {
    let choice = "1";
    while (choice !== "0") {
        choice = await rl.question(menuMessage);
        console.log();
        switch (choice) {
            case "1":
                const dwarfname = await rl.question("Введите имя дварфа: ");
                console.log();
                await query1(dwarfname);
                break;

            case "2":
                await query2();
                break;

            case "3":
                await query3();
                break;

            case "4":
                await query4();
                break;

            case "5":
                await query5();
                break;

            case "6":
                await query6();
                break;

            case "7":
                await query7();
                break;
            case "7.1":
                await query7_1();
                break;

            case "8":
                await query8();
                break;

            case "9":
                await query9();
                break;

            case "10":
                const name = await rl.question("Введите имя назгула: ");
                const race = await rl.question("И его расу: ");
                const master = await rl.question("Кто его мастер? ");
                await query10(name, race, master);

            case "0":
                console.log("Спасибо, что пользовались данной программой :)");
                break;
            default:
                console.log("Неправильный ввод!");
                break;
        }
    }
    rl.close();
}