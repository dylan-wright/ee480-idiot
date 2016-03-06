/*  
 *  EE480 - Assignment 2: The Making Of An IDIOT
 *  proccesor.v - top level module
 *  Version:
 *      03-02 : initial version
 *      03-03 : integrated ALU
 */

`include "signals.v"

module proccesor (
    input reset,
    input clk
    );

    //ALU registers and data lines
    reg `WORD X;
    reg `WORD Y;
    reg `WORD Z;
    wire [2:0] ALUop;
    wire `WORD z;

    //Register file datalines
    wire `WORD reg_data_out;
    reg `WORD reg_data_in;
    reg [5:0] reg_sel;
    reg [1:0] reg_mode;
    reg reg_clear;

    //Memory registers and data lines
    wire `WORD mem_data_out;
    reg `WORD mem_data_in;
    reg [1:0] mem_mode;
    reg `WORD mem_address;

    //Module instantiation
    alu alu_mod(X,
                Y,
                ALUop,
                z);
    register_file register_file_mod(reg_data_out,
                                    reg_data_in,
                                    reg_sel,
                                    reg_mode,
                                    clk,
                                    reg_clear);
    memory memory_mod(mem_data_out,
                      mem_data_in,
                      mem_mode,
                      mem_address,
                      clk);

    always @(posedge clk)
    begin
        Z <= z;
    end
endmodule
