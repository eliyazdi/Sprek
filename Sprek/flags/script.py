import os

unis = {
    '🇦': 'A',
    '🇧': 'B',
    '🇨': 'C',
    '🇩': 'D',
    '🇪': 'E',
    '🇫': 'F',
    '🇬': 'G',
    '🇭': 'H',
    '🇮': 'I',
    '🇯': 'J',
    '🇰': 'K',
    '🇱': 'L',
    '🇲': 'M',
    '🇳': 'N',
    '🇴': 'O',
    '🇵': 'P',
    '🇶': 'Q',
    '🇷': 'R',
    '🇸': 'S',
    '🇹': 'T',
    '🇺': 'U',
    '🇻': 'V',
    '🇼': 'W',
    '🇽': 'X',
    '🇾': 'Y',
    '🇿': 'Z'
}

for filename in os.listdir("."):
    if filename.startswith("1f1"):
        rawname = filename.split(".")
        rawname = rawname[0]
        hexes = rawname.split("-")
        b = ""
        a = unis[chr(int(hexes[0], 16))]
        try:
            b = unis[chr(int(hexes[1], 16))]
        except:
            b = ""
        name = a + b
        os.rename(filename, name+'.png')
