const fs = require('fs');
const readline = require('readline');

const dataDirectory = "./data";
const csvDirectory = "./csv";
const dwarfsFilename = "dwarfs.csv";
if (!fs.existsSync(dataDirectory)) {
    fs.mkdirSync(dataDirectory)
}
if (!fs.existsSync(csvDirectory)) {
    fs.mkdirSync(csvDirectory)
}
fs.writeFile(`${csvDirectory}/${dwarfsFilename}`, "id, name, gender, height, beird, skill, weight, age",(err) => {if (err) console.log(err);});

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

let id = 1;

function writeDwarf(name, gender) {
    let skill = possibleSkills[Math.floor(Math.random()*possibleSkills.length)];
    let height = (Math.floor(Math.random() * 50) + 70).toString();
    let weight = (Math.floor(Math.random() * 40) + 30).toString();
    let age = (Math.floor(Math.random() * 350) + 50).toString();
    let beird = (Math.floor(Math.random() * 40) + 10).toString();
    let dwarf = String.prototype.concat(
        "\n",
        id, ",",
        name, ",",
        gender, ",",
        height, ",",
        beird, ",",
        skill, ",",
        weight, ",",
        age,
    );
    id++;
    fs.appendFile(`${csvDirectory}/${dwarfsFilename}`, dwarf , (err) => {if (err) console.log(err);});
}

const maledwarfInterface = readline.createInterface({
    input: fs.createReadStream(`${dataDirectory}/dwarfsNames.txt`),
});

maledwarfInterface.on('line', function(line) {
    let name = line;
    writeDwarf(name, "Male");
});

maledwarfInterface.on('close', () => {
    const femaledwarfInterface = readline.createInterface({
        input: fs.createReadStream(`${dataDirectory}/dwarfsNames.txt`),
    });

    femaledwarfInterface.on('line', function(line) {
        let name = line + 's';
        writeDwarf(name, "Female");
    });
});
