`include "signals.v"

module register_file(data_out, data_in, reg_sel, mode, clk, clear);
    input [5:0] reg_sel;
    input [1:0] mode;
    input clk;
    input `WORD data_in;
    output `WORD data_out;
    input clear;

    reg `WORD d;

    //64 WORD width registers
    reg `WORD registers[0:63];

    //internal reset var
    reg [5:0] i;

    assign data_out = (mode == `regModeOut) ? d : 16'bZ;

    always @(posedge clk) begin
        if (mode == `regModeIn) begin
            $display("Write registers[%d] = %d", reg_sel, data_in);
            registers[reg_sel] = data_in;
        end else if (mode == `regModeOut) begin
            $display("Read register[%d] -> %d", reg_sel, d);
            d = registers[reg_sel];
        end
    end

    always @(posedge clear) begin
        $display("Clear register file");
        i = 0;
        repeat(64) begin
            registers[i] = 0;
            i+=1;
        end
    end
endmodule
