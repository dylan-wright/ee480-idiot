#!/usr/bin/python3
'''
    Dylan Wright - dylan.wright@uky.edu
    EE480 - Assignment 2: The Making Of An IDIOT
    diss.py : splits text segment of output from aik.py into
              fields. Lengths configured by changing constants
              in print_fields
    Version:
        02-15-2016 : initial
        02-16-2016 : added length vars
'''

OPLEN = 4
REGLEN = 6

def main():
    file_in = open(input(), "r")
    lines = file_in.read().split("\n")
    text = lines[3:lines.index("Data:")-1]

    for i in range(len(text)):
        text[i] = to_bin_str(text[i])

    print_diss(text)

def print_diss(text):
    print("OPCODE","FIELD", "FIELD", sep="\t")
    for i in range(len(text)):
        print_fields(text[i])

def print_fields(instruct):
    print(instruct[:OPLEN],instruct[OPLEN:OPLEN+REGLEN],instruct[OPLEN+REGLEN:], sep="\t")

def to_bin_str(hex_str):
    bin_str = str(bin(int(hex_str, 16)))[2:]
    return (16-len(bin_str))*"0" + bin_str

main()
