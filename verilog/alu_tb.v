`include "signals.v"

module alu_tb;
    function disp;
    input x,y,z;
    begin
        $display("X:%d\nY:%d\nZ:%d",x,y,z);
    end
    endfunction

    //interface to uut
    reg `WORD X;
    reg `WORD Y;
    reg `WORD Z;
    wire `WORD z;
    reg [2:0] ALUop;
    alu aluuut(X,Y,ALUop,z);

    integer correct, failed;
    reg `WORD calc;

    initial begin
        correct = 0;
        failed = 0;
        X = 0;
        Y = 0;
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        //wait a bit
        #5;

        //loop through operators
        for (ALUop = `ALUadd; ALUop < `ALUshr; ALUop+=1)
        begin
            // 0000 0000
            #1;
            // ffff 0000
            X = 16'hffff;
#1;
            // ffff ffff
            Y = 16'hffff;
#1;
            // 0000 ffff
            X = 0;
#1;
        end

        $display("Testing finished with %d correct %d failed", correct, failed);
        $finish;
    end

    always #1 Z = z;
endmodule
