# ee480-idiot
EE 480 Assignment 2: The Making of an IDIOT

Files (may not be 100% complete but contains important files):
/
    | IDIOT/
        | Directory containing IDIOT Instruction Set spec
        | progs/
            | contains idiot programs and correct out. used for testing spec
    | verilog/
        | Directory containing verilog modules
        | proccesor.v - top level module
        | control.v - FSM which controls top level module
        | alu.v
        | register_file.v
        | test.sh - test script to run each of the following test benches
        | memory.v
        | proccesor_tb.v
        | alu_tb.v
        | memory_tb.v
        | register_file_tb.v
        | tests/
            | Directory containing test vectors
            | proccesor/
                | test vectors for testing top level module 
    | Documentation/
        | Directory containing documentation source files
        | notes.tex - implementer's notes source
        | Makefile - to make implementer's notes
