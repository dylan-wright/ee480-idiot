`include "signals.v"

module register_file(data_out, data_in, reg_sel, mode, clk, clear,u0);
    input [5:0] reg_sel;
    input [1:0] mode;
    input clk;
    input `WORD data_in;
    output reg `WORD data_out;
    input clear;

    reg `WORD d;

    //64 WORD width registers
    reg `WORD registers[0:63];
    output `WORD u0;
    wire `WORD fp, sp, ra;

    //internal reset var
    reg [5:0] i;

    //assign data_out = d;
assign u0 = registers[11];
assign fp = registers[5];
assign sp = registers[4];
assign ra = registers[6];

    always @(posedge clk) begin
        if (mode == `regModeIn) begin
            registers[reg_sel] <= data_in;
        end
        else if (mode == `regModeOut) begin
            data_out <= registers[reg_sel];
        end

    end

    always @(clear) begin
        i = 0;
        repeat(64) begin
            registers[i] = 0;
            i+=1;
        end
    end

    initial begin
        registers[0] = 0;
        registers[1] = 1;
        registers[2] = 16'h8000;
        registers[3] = 16'hffff;
        registers[4] = 0;
        registers[5] = 0;
        registers[6] = 0;
    end
endmodule
