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
    integer suc, fail;

    register_file uut(data_out, data_in, reg_sel, mode, clk, clear, testreg);

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);
        suc = 0;
        fail = 0;

        clk = 0;
        mode = `memModeIn;

        for (reg_sel = 0; reg_sel < 63; reg_sel += 1) begin
            data_in = reg_sel;
            #1 clk = 1; #1 clk = 0;
        end

        mode = `memModeOut;
        for (reg_sel = 0; reg_sel < 63; reg_sel += 1) begin
            #1 clk = 1; #1 clk = 0;
            if (data_out != reg_sel) begin
                $display("Failure reg[%d] -> %d", reg_sel, data_out);
                fail += 1;
            end else begin
                suc += 1;
            end
        end

        $display("Testing finished with %d correct %d failed", suc, fail);
    end

endmodule
