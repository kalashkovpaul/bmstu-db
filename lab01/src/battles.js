const fs = require('fs');
const readline = require('readline');

const dataDirectory = "./data";
const csvDirectory = "./csv";
const battlesFilename = "battles.csv";
if (!fs.existsSync(dataDirectory)) {
    fs.mkdirSync(dataDirectory)
}
if (!fs.existsSync(csvDirectory)) {
    fs.mkdirSync(csvDirectory)
}
fs.writeFile(`${csvDirectory}/${battlesFilename}`, "id, name, place, yearsAgo, reason, duration", (err) => {if (err) console.log(err);});

let id = 1;

const possiblePlaces = [
    "Numenor",
    "Gondor",
    "Mordor",
    "Rohan",
    "Harad",
    "Lost Lands",
];

const possibleReasons = [
    "Terrytory",
    "Resourses",
    "Love",
    "Money",
    "Life",
    "Vengeance",
    "Future",
    "Power"
];

function writeBattle(name) {
    let place = possiblePlaces[Math.floor(Math.random()*possiblePlaces.length)];
    let yearsAgo = (Math.floor(Math.random() * 8000) + 1).toString();
    let reason = possibleReasons[Math.floor(Math.random()*possibleReasons.length)];
    let duration = (Math.floor(Math.random() * 10000) + 1).toString();
    let battle = String.prototype.concat(
        "\n",
        id, ", ",
        name, ", ",
        place, ", ",
        yearsAgo, ", ",
        reason, ", ",
        duration
    );
    id++;
    fs.appendFile(`${csvDirectory}/${battlesFilename}`, battle , (err) => {if (err) console.log(err);});
}

const battlesInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/battlesNames.txt`),
});

battlesInterface.on('line', function(name) {
    writeBattle(name);
});
