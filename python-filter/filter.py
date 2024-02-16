import sys
import pykakasi
from jamdict import Jamdict

transcribed_index = 0

def process(line, output):
    global transcribed_index
    elements = line.split('\t')

    # Skip if the word doesn't contain any kanji
    if not any(char.isalpha() and ord(char) >= 0x4E00 and ord(char) <= 0x9FFF for char in elements[2]):
        return
    
    # Skip if the word is a number like 四十二 (without removing 一 and 十 for real words containing them)
    if len(elements[2]) > 2 and any(char in '二三四五六七八九' for char in elements[2]):
        return
    
    transcribed_index += 1
    print('{:.2f}'.format(100*transcribed_index/50000), '% done', end='\r')
    output.write(transcribe(elements))
    if transcribed_index >= 50000:
        sys.exit(0)

def transcribe(elements):
    katakana = elements[1]
    katakana = katakana.replace('スル', '') # JMdict doesn't have entries for する verbs but for the noun only
    kks = pykakasi.kakasi()
    result = kks.convert(katakana)

    # Extract the JMdict definitions
    entries = str(Jamdict().lookup(elements[2][0:-1]).entries)
    definitions = ''.join(entries.split(":")[1:])
    for i in range(2, 20):
        definitions = definitions.replace(f' {i}. ', '$')
    definitions = definitions.replace(' 1. ', '')
    english = ' | '.join(definitions.replace('/', ', ').split('$'))[:-1]

    return '\t'.join([elements[0], str(transcribed_index), result[0]['hepburn'], result[0]['hira'], elements[2][:-1], english])+'\n'

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python filter.py <input_file>")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = "words.tsv"
    with open(input_file, 'r') as file, open(output_file, 'w') as output:
        index = 0
        for line in file:
            index += 1
            process(line, output)