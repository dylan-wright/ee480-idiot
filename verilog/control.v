`include "signals.v"

module control(clk, ir, bus,
                ALUop, regMode, memMode,
                PCBusMode, IRBusMode,
                MARBusMode, MDRBusMode, MDRMemMode);
    input clk;
    output `WORD bus;
    output [2:0] ALUop;
    output [1:0] regMode;
    output [1:0] memMode;
    reg [7:0] state;
    output [1:0] PCBusMode;
    output [1:0] IRBusMode;
    output [1:0] MARBusMode;
    output [1:0] MDRBusMode;
    output [1:0] MDRMemMode;

    reg [1:0] pcbm, irbm, marbm, mdrbm, mdrmm;

    assign PCBusMode = pcbm;
    assign IRBusMode = irbm;
    assign MARBusMode = marbm;
    assign MDRBusMode = mdrbm;
    assign MDRMemMode = mdrmm;

    parameter LOADSTART_0       = 8'b00000000,
              LOADSTART_1       = 8'b00000001,
              LOADINSTRUCT_0    = 8'b00000010,
              LOADINSTRUCT_1    = 8'b00000011,
              LOADINSTRUCT_2    = 8'b00000100,
              LOADINSTRUCT_3    = 8'b00000101;

    always @(state) begin
        case (state)
            LOADSTART_0:    begin 
                                bus = 0;
                                pcbm = `PCBusR;
                            end
            LOADSTART_1:    begin
                                bus = 16'bZ;
                                pscbm = 0;
                            end
            LOADINSTRUCT_0: begin 
                                pcbm = `PCBusW;
                                marbm = `MARBusR;
                            end
            LOADINSTRUCT_1: begin
                                pcbm = 0;
                                marbm = 0;
                                memMode = `memModeOut;
                                mdrbm = `MARBusR;
                            end
            LOADINSTRUCT_2: begin
                                memMode = 0;
                                mdrmm = 0;
                                mdrbm = `MDRBusW;
                                irbm = `IRBusR;
                            end
            LOADINSTRUCT_3: begin
                                mdrbm = 0;
                                irbm = 0;
                            end
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
        endcase
    end
endmodule
