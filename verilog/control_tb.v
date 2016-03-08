module control_tb;
    reg clk, reset;
    reg `WORD ir;
    wire PCInc, PCNext, PCReset;
    wire [1:0] PCBusMode, IRBusMode, XBusMode, YBusMode, ZBusMode, RegMode,
               MARBusMode, MDRBusMode, MDRMemMode, MemMode;
    wire [2:0] ALUOp;
    wire [5:0] RegAddr;

    control uut(clk,
                reset,
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
        clk = 0;
        reset = 0;
        ir = 16'b0;
    end

    always #2 clk = !clk;
endmodule
