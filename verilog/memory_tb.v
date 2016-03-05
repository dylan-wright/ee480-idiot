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

    end

endmodule
