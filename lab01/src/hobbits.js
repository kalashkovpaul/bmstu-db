const fs = require('fs');
const readline = require('readline');

const dataDirectory = "./data";
const csvDirectory = "./csv";
const hobbitsFilename = "hobbits.csv";
if (!fs.existsSync(dataDirectory)) {
    fs.mkdirSync(dataDirectory)
}
if (!fs.existsSync(csvDirectory)) {
    fs.mkdirSync(csvDirectory)
}
fs.writeFile(`${csvDirectory}/${hobbitsFilename}`, "id, name, surname, residence, class, height, weight, gender, age, adventure", (err) => {if (err) console.log(err);});

const possibleResidences = [
    "Shire",
    "Eastfarthing",
    "Southfarthing",
    "Northfarthing",
    "Westfarthing",
    "Buckland",
    "Westmarch",
    "Bridgefields",
    "Green Hill",
    "Marish",
    "Tookland",
    "Woody End",
    "Bywater",
    "Hobbiton",
    "Tuckborough"
];

const possibleClasses = [
    "Harfoot",
    "Stoor",
    "Fallohide"
];

let id = 1;

function writeHobbit(name, surname, gender) {
    let residence = possibleResidences[Math.floor(Math.random()*possibleResidences.length)];
    let hobbitClass = possibleClasses[Math.floor(Math.random()*possibleClasses.length)];
    let height = (Math.floor(Math.random() * 40) + 60).toString();
    let weight = (Math.floor(Math.random() * 20) + 20).toString();
    let age = (Math.floor(Math.random() * 60) + 33).toString();
    let adventure = (Math.floor(Math.random() * 10) + 1).toString();
    let hobbit = String.prototype.concat(
        "\n",
        id, ", ",
        name, ", ",
        surname, ", ",
        residence, ", ",
        hobbitClass, ", ",
        height, ", ",
        weight, ", ",
        gender, ", ",
        age, ", ",
        adventure
    );
    id++;
    fs.appendFile(`${csvDirectory}/${hobbitsFilename}`, hobbit , (err) => {if (err) console.log(err);});
}

const maleHobbitInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/hobbitsMaleNames.txt`),
});

maleHobbitInterface.on('line', function(line) {
    let [name, surname] = line.split(" ", 2);
    writeHobbit(name, surname, "Male");
});

maleHobbitInterface.on('close', () => {
    const femaleHobbitInterface = readline.createInterface({
        input: fs.createReadStream(`${dataDirectory}/hobbitsFemaleNames.txt`),
    });

    femaleHobbitInterface.on('line', function(line) {
        let [name, surname] = line.split(" ", 2);
        writeHobbit(name, surname, "Female");
    });
});
