`include "signals.v"

module control(clk, ir, bus,
                ALUop, regMode, memMode);
    input clk;
    output [2:0] ALUop;
    output [1:0] regMode;
    output [1:0] memMode;

    always @(posedge clk) begin

    end
endmodule
