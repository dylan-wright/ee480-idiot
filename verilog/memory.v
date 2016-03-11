`include "signals.v"

module memory(data_out, data_in, mode, address, clk);
    output `WORD data_out;
    input `WORD data_in;
    input [1:0] mode;
    input `WORD address;
    input clk;

    reg `WORD mem[0:65536];

    reg `WORD d;

    wire `WORD testout;

    assign data_out = d;

    always @(posedge clk) begin
        if (mode == `memModeIn) begin
            mem[address] = data_in;
        end else if (mode == `memModeOut) begin
            d = mem[address];
        end
    end
    
    initial begin
        //$readmemh("test-custom.vmem", mem);
        $readmemh("tests/proccesor/proccesor-test-custom.vmem", mem);
    end
endmodule
