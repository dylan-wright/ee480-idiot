`include "signals.v"

module control(
    clk,
    reset,
    Bus,
    PCBusMode,
    PCNext,
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
    MemMode
);
//Port dec
input clk;
input reset;

output reg `WORD Bus;

output reg [1:0] PCBusMode;
output reg PCNext;
output reg PCReset;

input `WORD ir;
output reg [1:0] IRBusMode;

output reg [2:0] ALUOp;
output reg [1:0] XBusMode;
output reg [1:0] YBusMode;
output reg [1:0] ZBusMode;

output reg [5:0] RegAddr;
output reg [1:0] RegMode;

output reg [1:0] MARBusMode;
output reg [1:0] MDRBusMode;
output reg [1:0] MDRMemMode;
output reg [1:0] MemMode;

//internals
reg [1:0] regSel;
wire [3:0] irOp;
wire [5:0] irReg1, irReg2;

//State def
parameter PCLOAD_0 = 0,
          NEXTIR_0 = 100,
          NEXTIR_1 = 101,
          NEXTIR_2 = 102,
          NEXTIR_3 = 103,
          OPDECODE_0 = 200,
          ALUOP_0 = 300,
          ALUOP_1 = 301,
          ALUOP_2 = 302,
          ALUOP_3 = 303,
          LDOP_0 = 400,
          LDOP_1 = 401,
          LDOP_2 = 402,
          STOP_0 = 500,
          STOP_1 = 501,
          STOP_2 = 502,
          LIOP_0 = 600,
          LIOP_1 = 601,
          LIOP_2 = 602,
          LIOP_3 = 603,
          LIOP_4 = 604,
          LIOP_5 = 605,
          JOP_0 = 700,
          JOP_A1 = 701,
          JOP_A2 = 702,
          JOP_B1 = 751,
          JOP_B2 = 752,
          JOP_3 = 703,
          JOP_4 = 704,
          JOP_5 = 705,
          JOP_6 = 706,
          JOP_7 = 707,
          JOP_8 = 708,
          INCPC_0 = 800;

reg `WORD state, next_state;

assign irOp = ir[15:12];
assign irReg1 = ir[11:6];
assign irReg2 = ir[5:0];

//combinational
always @(state) begin
    next_state = 0;
    case (state) 
        PCLOAD_0:   next_state = NEXTIR_0;
        NEXTIR_0:   next_state = NEXTIR_1;
        NEXTIR_1:   next_state = NEXTIR_2;
        NEXTIR_2:   next_state = NEXTIR_3;
        NEXTIR_3:   next_state = OPDECODE_0;
        OPDECODE_0: begin
                        // switch on op code
                        // for now lazy - see if loop works
                        next_state = INCPC_0;
                    end
        ALUOP_0:    next_state = ALUOP_1;
        ALUOP_1:    next_state = ALUOP_2;
        ALUOP_2:    next_state = ALUOP_3;
        ALUOP_3:    next_state = INCPC_0;
        LDOP_0:     next_state = LDOP_1;
        LDOP_1:     next_state = LDOP_2;
        STOP_0:     next_state = STOP_1;
        STOP_1:     next_state = STOP_2;
        STOP_2:     next_state = INCPC_0;
        LIOP_0:     next_state = LIOP_1;
        LIOP_1:     next_state = LIOP_2;
        LIOP_2:     next_state = LIOP_3;
        LIOP_3:     next_state = LIOP_4;
        LIOP_4:     next_state = LIOP_5;
        LIOP_5:     next_state = INCPC_0;
        JOP_0:      begin
                        // switch on value of reg 2
                        // for now lazy 
                        next_state = 16'bX;
                    end
        JOP_A1:     next_state = JOP_A2;
        JOP_A2:     next_state = JOP_3;
        JOP_B1:     next_state = JOP_B2;
        JOP_B2:     next_state = JOP_3;
        JOP_3:      next_state = JOP_4;
        JOP_4:      next_state = JOP_5;
        JOP_5:      next_state = JOP_6;
        JOP_6:      next_state = JOP_7;
        JOP_7:      begin
                        if (ir == 0) begin
                            next_state = JOP_8;
                        end else begin
                            next_state = INCPC_0;
                        end
                    end
        JOP_8:      next_state = INCPC_0;
        INCPC_0:    next_state = NEXTIR_0;
    endcase
end

//sequential
always @(posedge clk) begin
        PCBusMode <= 0;
        PCNext <= 0;
        PCReset <= 0;
        IRBusMode <= 0;
        ALUOp <= 0;
        XBusMode <= 0;
        YBusMode <= 0;
        ZBusMode <= 0;
        RegAddr <= 0;
        RegMode <= 0;
        MARBusMode <= 0;
        MDRBusMode <= 0;
        MDRMemMode <= 0;
        MemMode <= 0;
    if (reset == 1) begin
        state <= PCLOAD_0;
    end else begin
        state <= next_state;
        case (state)
            PCLOAD_0:   begin
                            PCReset <= 1;
                        end
            NEXTIR_0:   begin
                            PCBusMode <= `PCBusW;
                        end
            NEXTIR_1:   begin
                            MARBusMode <= `MARBusR;
                            MemMode <= `memModeOut;
                            MDRMemMode <= `MDRMemR;
                        end
            NEXTIR_2:   begin
                            MemMode <= `memModeOut;
                            MDRMemMode <= `MDRMemR;
                        end
            NEXTIR_3:   begin
                            MDRBusMode <= `MDRBusW;
                            IRBusMode <= `IRBusR;
                        end
            OPDECODE_0: begin

                        end
            INCPC_0:    begin
                            PCNext <= 1;
                        end
            ALUOP_0:    begin
                            XBusMode <= `BusRead;
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            ALUOP_1:    begin
                            YBusMode <= `BusRead;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            ALUOP_2:    begin
                            //Instruction op code
                        end
            ALUOP_3:    begin
                            ZBusMode <= `BusWrite;
                            regSel <= 1;
                            RegMode <= `regModeIn;
                        end
            LDOP_0:     begin
                            MARBusMode <= `MARBusR;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            LDOP_1:     begin
                            MDRMemMode <= `MDRMemR;
                            MemMode <= `memModeIn;
                        end
            LDOP_2:     begin
                            MDRBusMode <= `MDRBusW;
                            regSel <= 1;
                            RegMode <= `regModeIn;
                        end
            STOP_0:     begin
                            MARBusMode <= `MARBusR;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            STOP_1:     begin
                            MDRBusMode <= `MDRBusR;
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            STOP_2:     begin
                            MDRMemMode <= `MDRMemW;
                            MemMode <= `memModeIn;
                        end
            LIOP_0:     begin
                            XBusMode <= `BusRead;
                            PCBusMode <= `PCBusW;
                        end
            LIOP_1:     begin
                            YBusMode <= `BusRead;
                            Bus <= 1;
                        end
            LIOP_2:     begin
                            ALUOp <= `ALUadd;
                        end
            LIOP_3:     begin
                            ZBusMode <= `BusWrite;
                            MARBusMode <= `MARBusR;
                            PCBusMode <= `PCBusR;
                        end
            LIOP_4:     begin
                            MemMode <= `memModeIn;
                            MDRMemMode <= `MDRMemR;
                        end
            LIOP_5:     begin
                            regSel <= 1;
                            MDRBusMode <= `MDRBusW;
                            RegMode <= `regModeIn;
                        end
            JOP_0:      begin
                        end
            JOP_A1:     begin
                            regSel <= 1;
                            RegMode <= `regModeOut;
                            XBusMode <= `BusRead;
                        end
            JOP_A2:     begin
                            Bus <= -1;
                            YBusMode <= `BusRead;
                        end
            JOP_B1:     begin
                            regSel <= 1;
                            RegMode <= 1;
                        end
            JOP_B2:     begin
                            Bus <= 1;
                            YBusMode <= `BusRead;
                        end
            JOP_3:      begin
                            ALUOp <= `ALUadd;
                        end
            JOP_4:      begin
                            ZBusMode <= `BusWrite;
                            MARBusMode <= `MARBusW;
                        end
            JOP_5:      begin
                            regSel <= 1;
                            RegMode <= `regModeOut;
                            XBusMode <= `BusRead;
                        end
            JOP_6:      begin
                            ALUOp <= `ALUany;
                        end
            JOP_7:      begin
                            ZBusMode <= `BusWrite;
                            IRBusMode <= `IRBusR;
                        end
            JOP_8:      begin
                            PCBusMode <= `PCBusR;
                            MARBusMode <= `MARBusW;
                        end
        endcase
    end
end
endmodule
