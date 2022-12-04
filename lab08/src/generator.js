const fs = require('fs');
const readline = require('readline');

const dataDirectory = "./data";
const jsonDirectory = "./json";
const table = "hobbits";
if (!fs.existsSync(dataDirectory)) {
    fs.mkdirSync(dataDirectory)
}
if (!fs.existsSync(jsonDirectory)) {
    fs.mkdirSync(jsonDirectory)
}
// fs.writeFile(`${jsonDirectory}/${hobbitsFilename}`, "[",(err) => {if (err) console.log(err);});

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
let maleNames = [];
let femaleNames = [];

function writeHobbit(name, surname, gender) {
    let hobbitsFilename = id + "_" + table + "_" + (new Date()).toString().replace(" ", "_") + ".json"
    let residence = possibleResidences[Math.floor(Math.random()*possibleResidences.length)];
    let hobbitClass = possibleClasses[Math.floor(Math.random()*possibleClasses.length)];
    let height = (Math.floor(Math.random() * 40) + 60).toString();
    let weight = (Math.floor(Math.random() * 20) + 20).toString();
    let age = (Math.floor(Math.random() * 60) + 33).toString();
    let adventure = (Math.floor(Math.random() * 10) + 1).toString();
    let hobbit = `{"id":${id},"name":"${name}","surname":"${surname}","residence":"${residence}","class":"${hobbitClass}","height":${height},"weight":${weight},"age":${age},"gender":"${gender}","adventure":${adventure}}`
    fs.appendFile(`${jsonDirectory}/${hobbitsFilename}`, hobbit , (err) => {if (err) console.log(err);});
    id++;
}

const maleHobbitInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/hobbitsMaleNames.txt`),
});

maleHobbitInterface.on('line', function(line) {
    let [name, surname] = line.split(" ",2);
    maleNames.push({name, surname});
    // writeHobbit(name, surname, "Male");
});

maleHobbitInterface.on('close', () => {
    const femaleHobbitInterface = readline.createInterface({
        input: fs.createReadStream(`${dataDirectory}/hobbitsFemaleNames.txt`),
    });

    femaleHobbitInterface.on('line', function(line) {
        let [name, surname] = line.split(" ",2);
        femaleNames.push({name, surname});
        // writeHobbit(name, surname, "Female");
    });
});

let i = 0;

setInterval(() => {
    writeHobbit(maleNames[i].name, maleNames[i].surname, "Male");
    i++
}, 1000);
