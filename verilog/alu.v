/*  EE480 - Assignment 2: The Making Of An IDIOT
 *  proccesor.v - top level module
 *  Version:
 *      03-02 : initial version
 *      03-03 : started ops
 */

`include "signals.v"

module alu(X, Y, ALUop, Z);
    input `WORD X;
    input `WORD Y;
    input [2:0] ALUop;
    output reg `WORD Z;

    always @(X or Y or ALUop)
    begin
        case(ALUop)
            `ALUadd:    Z = X + Y;
            `ALUand:    Z = X & Y;
            `ALUor:     Z = X | Y;
            `ALUxor:    Z = X ^ Y;
            `ALUany:    Z = X != 0;
            `ALUshr:    Z = X >> 1;
            default:    Z = 16'b1;
        endcase
    end
endmodule
