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
    //ALU registers
    reg `WORD X;
    reg `WORD Y;
    reg `WORD Z;
    wire [2:0] ALUop;
    wire `WORD z;

    alu alumod(X,Y,ALUop,z);

    always @(posedge clk)
    begin
        Z <= z;
    end
endmodule
