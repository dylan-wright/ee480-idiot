/*  EE480 - Assignment 2: The Making Of An IDIOT
 *  signals.v : constant signal definitions
 *  Version:
 *      03-02 : initial version
 *      03-05 : added register file signals
 */

`define WORD   [15:0]

//ALU Ops
`define ALUadd 3'b000
`define ALUand 3'b001
`define ALUor  3'b010
`define ALUxor 3'b011
`define ALUany 3'b100
`define ALUshr 3'b101

//Register signals
`define regModeIn 2'b01
`define regModeOut 2'b10
