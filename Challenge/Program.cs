using System;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace Challenge;

class Program
{
    static void Main(string[] args)
    {

        // Check if the user has provided a path as an argument
        if (args.Length == 0 || string.IsNullOrEmpty(args[0]))
        {
            Console.WriteLine("Please provide the path to the input folder.");
            return;
        }

        // Get the input folder path from the argument
        string inputFolderPath = args[0];

        // Check if the provided path is a valid directory
        if (!Directory.Exists(inputFolderPath))
        {
            Console.WriteLine("The provided path is not a valid directory.");
            return;
        }
        
        // Ensure the output folder exists
        string outputFolderPath = Path.Combine(inputFolderPath, "resultat");
        Directory.CreateDirectory(outputFolderPath);

        // Get all input files in the input folder (any files)
        var inputFiles = Directory.GetFiles(inputFolderPath).Where(f => string.IsNullOrEmpty(Path.GetExtension(f))).ToArray();

        Console.WriteLine($"Looking for input files in: {inputFolderPath}");

        if (inputFiles.Length == 0)
        {
            Console.WriteLine("No input files found in the artefakter folder.");
            return;
        }

        foreach (var file in inputFiles)
        {
            Console.WriteLine(file);  // Debugging: Print each file name on a new line
        }

        // Process each input file dynamically based on the number of files found
        foreach (var inputFilePath in inputFiles)
        {
            // Get the input file name without the extension and create the corresponding output file name
            string outputFileName = Path.GetFileNameWithoutExtension(inputFilePath) + ".xml";
            string outputFilePath = Path.Combine(outputFolderPath, outputFileName);

            // Read and process the input file
            ProcessInputFile(inputFilePath, outputFilePath);
        }

        Console.WriteLine("All files processed successfully.");
    }

    static void ProcessInputFile(string inputFilePath, string outputFilePath)
    {
        // Read all lines from the input file
        string[] lines = File.ReadAllLines(inputFilePath);

        // Ensure the file has at least 3 lines to avoid out-of-bounds errors
        if (lines.Length < 3)
        {
            Console.WriteLine($"File {inputFilePath} does not contain the expected format.");
            return;
        }

        // Extract title, sender, and description from the input
        string title = GetValueFromLine(lines[0], "Titel");
        string sender = GetValueFromLine(lines[1], "Avsändare");
        string description = GetValueFromLine(lines[2], "Beskrivning");

        // Handle anonymous sender
        sender = string.IsNullOrWhiteSpace(sender) ? "Anonym" : FormatSenders(sender);

        // Create the XML document
        XDocument xmlDoc = new XDocument(
                new XElement("Ärende",
                new XElement("Rubrik", $"Förslag om {title} inskickad av {sender}"),
                new XElement("Beskrivning", description)
            )
        );

        // Save the XML to the output path
        xmlDoc.Save(outputFilePath);
    }

    // Arrow function to extract value from a line based on prefix
    static string GetValueFromLine(string line, string prefix) => line.Substring(prefix.Length + 2).Trim();

    // Arrow function to format multiple senders
    static string FormatSenders(string sender) =>
        sender.Split(',').Select(s => s.Trim()).ToArray() switch
        {
            var senders when senders.Length == 1 => senders[0],
            var senders => string.Join(", ", senders[..^1]) + " och " + senders[^1]
        };
}

