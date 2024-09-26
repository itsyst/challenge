using System;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace Challenge;

class Program
{
    static void Main(string[] args)
    {
        try
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

            int successCount = 0; // Counter for successfully processed files

            // Process each input file dynamically based on the number of files found
            foreach (var inputFilePath in inputFiles)
            {
                try
                {
                    // Get the input file name without the extension and create the corresponding output file name
                    string outputFileName = Path.GetFileNameWithoutExtension(inputFilePath) + ".xml";
                    string outputFilePath = Path.Combine(outputFolderPath, outputFileName);

                    // Read and process the input file
                    ProcessInputFile(inputFilePath, outputFilePath);
                    // If processing is successful, increment success count
                    Console.WriteLine($"Successfully processed: {inputFilePath} -> {outputFilePath}");
                    successCount++;
                }
                catch (Exception ex)
                {
                    // Log the error and skip to the next file
                    Console.WriteLine($"An error occurred while processing {inputFilePath}: {ex.Message}");
                }
            }

            // Output the number of successfully processed files
            Console.WriteLine($"{successCount} of {inputFiles.Length} files processed successfully.");
        }
        catch (DirectoryNotFoundException dirEx)
        {
            Console.WriteLine($"Error: The directory was not found. {dirEx.Message}");
        }
        catch (UnauthorizedAccessException unAuthEx)
        {
            Console.WriteLine($"Error: Access denied to the directory or file. {unAuthEx.Message}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An unexpected error occurred: {ex.Message}");
        }
    }

    static void ProcessInputFile(string inputFilePath, string outputFilePath)
    {
        // Read all lines from the input file and ignore empty lines
        string[] lines = File.ReadAllLines(inputFilePath)
                             .Select(line => line.Trim()) // Trim each line to remove excess spaces
                             .Where(line => !string.IsNullOrWhiteSpace(line)) // Ignore empty lines
                             .ToArray();

        // Ensure the file has at least 3 lines to avoid out-of-bounds errors
        if (lines.Length < 3)
        {
            throw new FormatException($"File {inputFilePath} does not contain the expected format.");
        }

        // Extract title, sender, and description from the input
        string title = GetValueFromLine(lines, "Titel");
        string sender = GetValueFromLine(lines, "Avsändare");
        string description = GetValueFromLine(lines, "Beskrivning");

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

    // Method to extract value from a line based on prefix
    static string GetValueFromLine(string[] lines, string prefix)
    {
        // Look for the line that starts with the expected prefix (ignoring case)
        string? line = lines.FirstOrDefault(l => l.StartsWith(prefix, StringComparison.OrdinalIgnoreCase));

        // If the line with the expected prefix is not found, return "Anonym" for "Avsändare"
        if (line == null)
        {
            if (prefix.Equals("Avsändare", StringComparison.OrdinalIgnoreCase))
            {
                return "Anonym";
            }
            throw new FormatException($"Error: Missing expected field '{prefix}' in the input file.");
        }

        // Ensure the line is long enough to contain a value after the prefix
        if (line.Length <= prefix.Length + 1)
        {
            // If the prefix is "Avsändare" and the value is missing, return "Anonym"
            if (prefix.Equals("Avsändare", StringComparison.OrdinalIgnoreCase))
            {
                return "Anonym";
            }
            throw new ArgumentException($"Error: Missing value after '{prefix}' in line: {line}");
        }

        // Extract and return the value after the prefix
        return line.Substring(prefix.Length + 2).Trim();
    }

    // Arrow function to format multiple senders
    static string FormatSenders(string sender) =>
        sender.Split(',').Select(s => s.Trim()).ToArray() switch
        {
            var senders when senders.Length == 1 => senders[0],
            var senders => string.Join(", ", senders[..^1]) + " och " + senders[^1]
        };
}
