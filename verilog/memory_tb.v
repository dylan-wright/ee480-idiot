`include "signals.v"

module memory_tb;
    wire `WORD data_out;
    reg `WORD data_in;
    reg [1:0] mode;
    reg `WORD address;
    reg clk;

    //instantiate uut
    memory uut(data_out, data_in, mode, address, clk);

    initial begin
        $dumpfile("memory_tb.vcd");
        $dumpvars(0, memory_tb);
        clk = 0;
        mode = 0;
        data_in = 16'hffff;
        address = 0;
        #1 clk = 1; mode = `memModeIn;
        #1 clk = 0;
        data_in = 16'hf0f0;
        address = 10;
        #1 clk = 1; mode = `memModeIn;
        #1 clk = 0;
        #1 clk = 1; mode = `memModeOut; $display("%d", data_out);
        #1 clk = 0;
        address = 0;
        #1 clk = 0; mode = `memModeOut; $display("%d", data_out);
        

    end

endmodule
