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
        mode = `memModeIn;
        for (address = 0; address < 65535; address += 1) begin
            data_in = address;
            #1 clk = 1;
            #1 clk = 0;
        end
        
        mode = `memModeOut;
        for (address = 0; address < 65535; address += 1) begin
            #1 clk = 1;
            #1 clk = 0;
            if (data_out != address) begin
                $display("Failure mem[%d] -> %d", address, data_out);
            end
        end
    end

endmodule
