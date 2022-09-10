const fs = require('fs');
const readline = require('readline');

const dataDirectory = "./data";
const csvDirectory = "./csv";
const orcsFilename = "orcs.csv";
if (!fs.existsSync(dataDirectory)) {
    fs.mkdirSync(dataDirectory)
}
if (!fs.existsSync(csvDirectory)) {
    fs.mkdirSync(csvDirectory)
}
fs.writeFile(`${csvDirectory}/${orcsFilename}`, "id, name, master, danger, endurance, bravery",(err) => {if (err) console.log(err);});

let id = 1;

const possibleMasters = [
    "Sauron",
    "Saruman",
    "Azog",
    "Nazguls",
    "Morgoth"
];

function writeOrc(name) {
    let master = possibleMasters[Math.floor(Math.random()*possibleMasters.length)];
    let danger = (Math.floor(Math.random() * 10) + 1).toString();
    let endurance = (Math.floor(Math.random() * 10) + 1).toString();
    let bravery = (Math.floor(Math.random() * 10) + 1).toString();
    let orc = String.prototype.concat(
        "\n",
        id, ",",
        name, ",",
        master, ",",
        danger, ",",
        endurance, ",",
        bravery
    );
    id++;
    fs.appendFile(`${csvDirectory}/${orcsFilename}`, orc , (err) => {if (err) console.log(err);});
}

const orcsInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/orcsNames.txt`),
});

orcsInterface.on('line', function(name) {
    writeOrc(name);
});
