import { menuMessage } from './consts.js';
import * as readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'process';
import { query1, query2} from './queries.js';
import { Console } from 'console';

const rl = readline.createInterface({ input, output });

export async function menu() {
    let choice = "1";
    while (choice !== "0") {
        choice = await rl.question(menuMessage);
        console.log();
        switch (choice) {
            case "1":
                await query1();
                break;

            case "2":
                const dwarfname = await rl.question("Введите имя дварфа: ");
                console.log();
                query2(dwarfname);
                break;

            case "3":
                console.log("TODO");
                break;

            case "4":
                console.log("TODO");
                break;

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