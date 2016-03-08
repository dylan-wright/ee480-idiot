`include "signals.v"

module control(clk, ir, bus,
                ALUop, regMode, memMode,
                PCBusmode, IRBusmode,
                MARBusMode, MDRBusMode, MDRMemMode);
    input clk;
    output `WORD bus;
    output [2:0] ALUop;
    output [1:0] regMode;
    output [1:0] memMode;
    reg [7:0] state;

    parameter LOADSTART_0       = 8'b00000000,
              LOADSTART_1       = 8'b00000001,
              LOADINSTRUCT_0    = 0'b00000010,
              LOADINSTRUCT_1    = 0'b00000011,
              LOADINSTRUCT_2    = 0'b00000100,
              LOADINSTRUCT_3    = 0'b00000101;

    always @(state) begin
        case (state)
            LOADSTART_0:    bus = 0;
                            PCmode = `PCBusR;
            LOADSTART_1:    bus = 16'bZ;
                            PCmode = 0;
            LOADINSTRUCT_0: PCmode = `PCBusW;
                            MARBusMode = `MARBusR;
            LOADINSTRUCT_1: PCmode = 0;
                            marMode = 0;
                            memMode = `memModeOut;
                            MDRMemMode = `MARMemR;
            LOADINSTRUCT_2: memMode = 0;
                            MDRMemMode = 0;
                            MDRBusMode = `MDRBusW;
                            IRBusMode = `IRBusR;
            LOADINSTRUCT_3: MDRBusMode = 0;
                            IRBusMode = 0;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            LOADSTART_0:    state = LOADSTART_1;
            LOADSTART_1:    state = LOADINSTRUCT_0;
            LOADINSTRUCT_0: state = LOADINSTRUCT_1;
            LOADINSTRUCT_1: state = LOADINSTRUCT_2;
            LOADINSTRUCT_2: state = LOADINSTRUCT_3;
            LOADINSTRUCT_3: state = LOADINSTRUCT_0;
            default:        state = 8'bX;
    end
endmodule
