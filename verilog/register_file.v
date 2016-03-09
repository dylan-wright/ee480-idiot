`include "signals.v"

module register_file(data_out, data_in, reg_sel, mode, clk, clear);
    input [5:0] reg_sel;
    input [1:0] mode;
    input clk;
    input `WORD data_in;
    output reg `WORD data_out;
    input clear;

    reg `WORD d;

    //64 WORD width registers
    reg `WORD registers[0:63];

    //internal reset var
    reg [5:0] i;

    //assign data_out = d;

    always @(posedge clk) begin
        if (mode == `regModeIn) begin
            registers[reg_sel] = data_in;
        end
        else if (mode == `regModeOut) begin
            data_out = registers[reg_sel];
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
        $readmemh("reginit.list", registers);
    end
endmodule
