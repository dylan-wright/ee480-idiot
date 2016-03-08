module control_tb;
    reg clk, reset;
    reg `WORD ir;
    wire PCInc, PCNext, PCReset;
    wire [1:0] PCBusMode, IRBusMode, XBusMode, YBusMode, ZBusMode, RegMode,
               MARBusMode, MDRBusMode, MDRMemMode, MemMode;
    wire [2:0] ALUOp;
    wire [5:0] RegAddr;
    wire `WORD Bus;

    control uut(clk,
                reset,
                Bus,
                PCBusMode,
                PCInc,
                PCReset,
                ir,
                IRBusMode,
                ALUOp,
                XBusMode,
                YBusMode,
                ZBusMode,
                RegAddr,
                RegMode,
                MARBusMode,
                MDRBusMode,
                MDRMemMode,
                MemMode);

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);
        clk = 0;
        reset = 1;
        #1 clk = 1;
        #1 clk = 0;
        reset = 0;
        ir = 16'b0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
#1 clk = 1;
#1 clk = 0;
    end

    always #100 $finish;
endmodule
