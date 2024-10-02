import os
import xml.etree.ElementTree as ET
from xml.dom import minidom
import argparse

def process_input_file(input_file, output_file):
    try:
        # Read all lines, trim spaces, and filter out empty lines
        with open(input_file, 'r', encoding='utf-8') as file:
            lines = [line.strip() for line in file if line.strip()]

        # Ensure there are at least 3 lines for Titel, Avsändare, Beskrivning
        if len(lines) < 3:
            print(f"File {input_file} does not contain the expected format.")
            return False

        title = get_value_from_line(lines, "Titel")
        sender = get_value_from_line(lines, "Avsändare")
        description = get_value_from_line(lines, "Beskrivning")

        # Handle anonymous sender
        sender = "Anonym" if not sender else format_senders(sender)

        # Create the XML structure
        root = ET.Element("Ärende")
        ET.SubElement(root, "Rubrik").text = f"Förslag om {title} inskickad av {sender}"
        ET.SubElement(root, "Beskrivning").text = description

        # Convert the ElementTree to a string
        xml_string = ET.tostring(root, encoding='utf-8', xml_declaration=True).decode('utf-8')

        # Use minidom to format the XML string
        formatted_xml = minidom.parseString(xml_string).toprettyxml(indent="  ", newl="\n")

        # Write to the output file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(formatted_xml)

        print(f"Successfully processed: {input_file} -> {output_file}")
        return True  # Return True to indicate successful processing

    except Exception as e:
        print(f"An error occurred while processing {input_file}: {str(e)}")
        return False  # Return False to indicate failure


def get_value_from_line(lines, prefix):
    for line in lines:
        if line.startswith(prefix):
            return line[len(prefix) + 1:].strip()
    if prefix == "Avsändare":
        return "Anonym"
    raise ValueError(f"Error: Missing '{prefix}' field in input file.")


def format_senders(sender):
    senders = [s.strip() for s in sender.split(',')]
    if len(senders) == 1:
        return senders[0]
    return ', '.join(senders[:-1]) + " och " + senders[-1]


def main():
    # Use argparse to accept the input folder as an argument
    parser = argparse.ArgumentParser(description='Process input files and convert them to XML.')
    parser.add_argument('input_folder', type=str, help='Path to the input folder')

    args = parser.parse_args()

    input_folder = args.input_folder
    output_folder = os.path.join(input_folder, "resultat")
    os.makedirs(output_folder, exist_ok=True)

    input_files = [f for f in os.listdir(input_folder) if os.path.isfile(os.path.join(input_folder, f))]
    success_count = 0
    total_files = len(input_files)

    for input_file in input_files:
        input_file_path = os.path.join(input_folder, input_file)
        output_file_path = os.path.join(output_folder, os.path.splitext(input_file)[0] + ".xml")

        try:
            # Only increment success_count if the file is processed successfully
            if process_input_file(input_file_path, output_file_path):
                success_count += 1
        except Exception as e:
            print(f"Error processing {input_file}: {str(e)}")

    # Output the correct number of successfully processed files
    print(f"{success_count} of {total_files} files processed successfully.")


if __name__ == "__main__":
    main()
