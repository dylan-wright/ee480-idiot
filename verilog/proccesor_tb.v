
module proccesor_tb;
    reg clk;
    reg reset;
    
    //instantiate uut
    proccesor uut(reset, clk);

    initial begin
        $dumpfile("proccesor_tb.vcd");
        $dumpvars(0, proccesor_tb);
        reset = 1;
        clk = 0;
        #1 clk = 1;
        #1 clk = 0; reset = 0;
    end

    always #5 clk = !clk;
    //always #10000 $finish;
endmodule
