`include "signals.v"

module proccesor_tb;
    reg clk;
    reg reset;
    
    //instantiate uut
    proccesor uut(reset, clk);

    initial begin
        $dumpfile("proccesor_tb.vcd");
        $dumpvars(0, proccesor_tb);

        clk = 0;
    end

    always #5 clk = !clk;
    always #100 $finish;
endmodule
