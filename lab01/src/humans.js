const fs = require('fs');
const readline = require('readline');

const dataDirectory = "./data";
const csvDirectory = "./csv";
const humansFilename = "humans.csv";
if (!fs.existsSync(dataDirectory)) {
    fs.mkdirSync(dataDirectory)
}
if (!fs.existsSync(csvDirectory)) {
    fs.mkdirSync(csvDirectory)
}
fs.writeFile(`${csvDirectory}/${humansFilename}`, "id, name, gender, age, country, skill, purpose", (err) => {if (err) console.log(err);});

const possibleCountries = [
    "Numenor",
    "Gondor",
    "Rohan",
    "Harad",
    "Arnor",
];

const possibleSkills = [
"Actor",
"Advocate",
"Alchemist",
"Animal",
"Handler",
"Apothecary",
"Architect",
"Archer",
"Archivist",
"Aristocrat",
"Armorer",
"Artisan",
"Artist",
"Astrologer",
"Baker",
"Banker",
"Barbarian",
"Barber",
"Bard",
"Barkeep",
"Barmaid",
"Beekeeper",
"Beer",
"Seller",
"Beggar",
"Blacksmith",
"Boatman",
"Bookbinder",
"Bookseller",
"Brewer",
"Bricklayer",
"Brick",
"Maker",
"Brigand",
"Brothel",
"Keeper",
"Buckle",
"Maker",
"Builder",
"Butcher",
"Caravan",
"Leader",
"Carpenter",
"Cartographer",
"Chandler",
"Charioteer",
"Chatelaine",
"Chef",
"Chieftain",
"Chirurgeon",
"Clergyman",
"Clerk",
"Clock",
"Maker",
"Clothworker",
"Cobbler",
"Commander",
"Concubine",
"Cook",
"Cooper",
"Copyist",
"Costermonger",
"Counselor",
"Courtesan",
"Courtier",
"Cowherd",
"Crossbowman",
"Cutler",
"Daimyo",
"Dairymaid",
"Dancer",
"Dictator",
"Diplomat",
"Distiller",
"Diver",
"Diviner",
"Doctor",
"Domestic",
"Servant",
"Emperor",
"Explorer",
"Farmer",
"Fighter",
"Fisherman",
"Fishmonger",
"Footman",
"Galley",
"Slave",
"Gardener",
"Geisha",
"General",
"Gladiator",
"Goldsmith",
"Grocer",
"Groom",
"Guardsman",
"Guildmaster",
"Infantryman",
"Innkeeper",
"Interpreter",
"Inventor",
"Jeweler",
"Jongleur",
"Judge",
"King",
"Kitchen",
"Knight",
"Laborer",
"Lady",
"Lord",
"Merchant",
"Messenger",
"Miner",
"Minister",
"Minstrel",
"Monk",
"Musician",
"Necromancer",
"Nurse",
"Painter",
"Philosopher",
"Pirate",
"Queen",
"Ranger",
"Slaver",
"Smith",
"Soldier",
"Merchant",
"Student",
"Swordsman",
"Teacher",
"Teamster",
"Thief",
"Torturer",
"Wrestler",
"Writer",
];

const possiblePurposes = [
    "Life",
    "Knowledge",
    "Power",
    "Family",
    "Money",
    "Communication",
    "Fame",
    "Kindness",
    "Evil"
];

let id = 1;

function writeHuman(name, gender) {
    let country = possibleCountries[Math.floor(Math.random()*possibleCountries.length)];
    let skill = possibleSkills[Math.floor(Math.random()*possibleSkills.length)];
    let purpose = possiblePurposes[Math.floor(Math.random()*possiblePurposes.length)];
    let age = (Math.floor(Math.random() * 60) + 33).toString();
    let human = String.prototype.concat(
        "\n",
        id, ", ",
        name, ", ",
        gender, ", ",
        age, ", ",
        country, ", ",
        skill, ", ",
        purpose
    );
    id++;
    fs.appendFile(`${csvDirectory}/${humansFilename}`, human , (err) => {if (err) console.log(err);});
}

const maleHumansInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/humansMaleNames.txt`),
});

maleHumansInterface.on('line', function(name) {
    writeHuman(name, "Male");
});

maleHumansInterface.on('close', () => {
    const femaleHumansInterface = readline.createInterface({
        input: fs.createReadStream(`${dataDirectory}/humansFemaleNames.txt`),
    });

    femaleHumansInterface.on('line', function(name) {
        writeHuman(name, "Female");
    });
});
