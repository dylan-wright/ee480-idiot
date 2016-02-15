def main():
    file_in = open(input(), "r")
    lines = file_in.read().split("\n")
    text = lines[3:lines.index("Data:")-1]
    for i in range(len(text)):
        text[i] = to_bin_str(text[i])
        print_fields(text[i])

def print_fields(instruct):
    print(instruct[:4],instruct[4:10],instruct[10:], sep="\t")
def to_bin_str(hex_str):
    bin_str = str(bin(int(hex_str, 16)))[2:]
    return (16-len(bin_str))*"0" + bin_str

main()
