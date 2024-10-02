const fs = require('fs');
const path = require('path');
const xml2js = require('xml2js');

function processInputFile(inputFile, outputFile) {
    try {
        // Read all lines, trim spaces, and filter out empty lines
        const lines = fs.readFileSync(inputFile, 'utf-8').split('\n')
            .map(line => line.trim())
            .filter(line => line.length > 0);

        // Ensure there are at least 3 lines for Titel, Avsändare, Beskrivning
        if (lines.length < 3) {
            console.log(`File ${inputFile} does not contain the expected format.`);
            return false;
        }

        const title = getValueFromLine(lines, "Titel");
        let sender = getValueFromLine(lines, "Avsändare");
        const description = getValueFromLine(lines, "Beskrivning");

        // Handle anonymous sender
        sender = sender ? formatSenders(sender) : "Anonym";

        // Create the XML structure
        const builder = new xml2js.Builder({ xmldec: { version: '1.0', encoding: 'UTF-8' } });
        const xmlObj = {
            Ärende: {
                Rubrik: `Förslag om ${title} inskickad av ${sender}`,
                Beskrivning: description
            }
        };

        const xml = builder.buildObject(xmlObj);
        fs.writeFileSync(outputFile, xml, 'utf-8');
        console.log(`Successfully processed: ${inputFile} -> ${outputFile}`);
        return true; // Return true to indicate successful processing

    } catch (error) {
        console.log(`An error occurred while processing ${inputFile}: ${error.message}`);
        return false; // Return false to indicate failure
    }
}

function getValueFromLine(lines, prefix) {
    for (let line of lines) {
        if (line.startsWith(prefix)) {
            return line.substring(prefix.length + 1).trim();
        }
    }
    if (prefix === "Avsändare") {
        return "Anonym";
    }
    throw new Error(`Error: Missing '${prefix}' field in input file.`);
}

function formatSenders(sender) {
    const senders = sender.split(',').map(s => s.trim());
    if (senders.length === 1) {
        return senders[0];
    }
    return `${senders.slice(0, -1).join(', ')} och ${senders[senders.length - 1]}`;
}

function main() {
    const inputFolder = process.argv[2]; // Get the input folder from command line arguments
    const outputFolder = path.join(inputFolder, 'resultat');
    fs.mkdirSync(outputFolder, { recursive: true });

    const inputFiles = fs.readdirSync(inputFolder).filter(file => fs.statSync(path.join(inputFolder, file)).isFile());
    let successCount = 0;
    const totalFiles = inputFiles.length;

    for (let inputFile of inputFiles) {
        const inputFilePath = path.join(inputFolder, inputFile);
        const outputFilePath = path.join(outputFolder, path.basename(inputFile, path.extname(inputFile)) + '.xml');

        // Only increment successCount if the file is processed successfully
        if (processInputFile(inputFilePath, outputFilePath)) {
            successCount++;
        }
    }

    // Output the correct number of successfully processed files
    console.log(`${successCount} of ${totalFiles} files processed successfully.`);
}

// Run the main function if the script is executed directly
if (require.main === module) {
    main();
}

// node 20.17.0
// npm  10.8.2
// npm install 