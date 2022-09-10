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
fs.writeFile(`${csvDirectory}/${hobbitsFilename}`, "name, surname, residence, class, height, weight, gender, age, adventure", (err) => {console.log(err)});

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

function writeHobbit(name, surname, gender) {
    let hobbit = name + ", " + surname + ", " +
        possibleResidences[Math.floor(Math.random()*possibleResidences.length)] + ", "
        possibleClasses[Math.floor(Math.random()*possibleClasses.length)] + ", " +
        (Math.floor(Math.random() * 40) + 60) + ", " +
        (Math.floor(Math.random() * 20) + 20) + ", " +
        gender + ", " +
        (Math.floor(Math.random() * 60) + 33) + ", " +
        (Math.floor(Math.random() * 10) + 1);
    fs.appendFile(`${csvDirectory}/${hobbitsFilename}`, hobbit, (err) => {console.log(err);});
}

const maleHobbitInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/hobbitsMaleNames.txt`),
});

const femaleHobbitInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/hobbitsFemaleNames.txt`),
});

maleHobbitInterface.on('line', function(line) {
    let name, surname = line.split();
    writeHobbit(name, surname, "Male");
});

femaleHobbitInterface.on('line', function(line) {
    let name, surname = line.split();
    writeHobbit(name, surname, "Female");
});


// fs.appendFile(`${dataDirectory}/tralala.txt`, JSON.stringify(content), (err) => {console.log(err);});