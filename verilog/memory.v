`include "signals.v"

module memory(data_out, data_in, mode, address, clk);
    output `WORD data_out;
    input `WORD data_in;
    input [1:0] mode;
    input `WORD address;
    input clk;

    reg `WORD mem[0:65536];

    always @(posedge clk) begin
        
    end

endmodule
