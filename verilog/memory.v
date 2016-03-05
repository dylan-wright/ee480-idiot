`include "signals.v"

module memory(data_out, data_in, mode, address, clk);
    output `WORD data_out;
    input `WORD data_in;
    input [1:0] mode;
    input `WORD address;
    input clk;

    reg `WORD mem[0:65536];

    reg `WORD d;

    assign data_out = (mode == `memModeOut) ? d : 16'bZ;

    always @(posedge clk) begin
        $display("Pos edge");
        if (mode == `regModeIn) begin
            $display("Write mem[%d] = %d", address, data_in);
            mem[address] = data_in;
        end else if (mode == `regModeOut) begin
            $display("Read mem[%d] <- %d", address, d);
        end
    end

endmodule
