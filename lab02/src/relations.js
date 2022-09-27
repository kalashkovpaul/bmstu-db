const fs = require('fs');
const readline = require('readline');

const csvDirectory = "./csv";
const relationsFilename = "orcBattles.csv";

if (!fs.existsSync(csvDirectory)) {
    fs.mkdirSync(csvDirectory)
}

function writeRelation(name) {
    let first = Math.floor(Math.random() * 1000) + 1;
    let second = Math.floor(Math.random() * 1000) + 1;
    fs.appendFile(`${csvDirectory}/${relationsFilename}`, `${first},${second}\n`, err => {if (err) console.log(err);});
}

for (let i = 0; i < 1000; i++) {
    writeRelation();
}
