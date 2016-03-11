`include "signals.v"

module register_file_tb;
    wire `WORD data_out;
    reg `WORD data_in;
    reg `WORD d;
    reg clk;
    reg [5:0] reg_sel;
    reg [1:0] mode;
    reg clear;
    wire `WORD testreg;

    register_file uut(data_out, data_in, reg_sel, mode, clk, clear, testreg);

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);
        clk = 0;
        clear = 1;
        #1 clk = 1;
        #1 clear = 0;
#1 clk = 0;
        data_in = 16'hf;
        mode = `regModeIn;
        reg_sel = 0;
        #1 clk = 1;
        #1 clk = 0;
        mode = `regModeOut;
        #1 clk = 1;
        #1 clk = 0;


    end

    always #10 $finish;

endmodule
