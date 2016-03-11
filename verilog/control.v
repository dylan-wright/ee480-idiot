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
    RegClear,
    MARBusMode,
    MDRBusMode,
    MDRMemMode,
    MemMode,
    ControlBusMode
);
//Port dec
input clk;
input reset;

output reg `WORD Bus;

output reg [1:0] PCBusMode;
output reg PCNext;
output reg PCReset;

input `WORD ir;
output reg [2:0] IRBusMode;

output reg [2:0] ALUOp;
output reg [1:0] XBusMode;
output reg [1:0] YBusMode;
output reg [1:0] ZBusMode;

output reg [5:0] RegAddr;
output reg [1:0] RegMode;
output reg RegClear;
output reg [1:0] MARBusMode;
output reg [1:0] MDRBusMode;
output reg [1:0] MDRMemMode;
output reg [1:0] MemMode;
output reg [1:0] ControlBusMode;

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
          OPDECODE_1 = 201,
          ALUOP_0 = 300,
          ALUOP_1 = 301,
          ALUOP_2 = 302,
          ALUOP_3 = 303,
          ALUOP_4 = 304,
          ALUOP_5 = 305,
          ALUOP_6 = 306,
          ALUOP_7 = 307,
          ALUOP_8 = 308,
          ALUOP_9 = 309,
          LDOP_0 = 400,
          LDOP_1 = 401,
          LDOP_2 = 402,
          LDOP_3 = 403,
          STOP_0 = 500,
          STOP_1 = 501,
          STOP_2 = 502,
          STOP_3 = 503,
          STOP_4 = 504,
          STOP_5 = 505,
          LIOP_0 = 600,
          LIOP_1 = 601,
          LIOP_2 = 602,
          LIOP_3 = 603,
          LIOP_4 = 604,
          LIOP_5 = 605,
          LIOP_6 = 606,
          LIOP_7 = 607,
          LIOP_8 = 608,
          LIOP_9 = 609,
          LIOP_10 = 610,
          JOP_0 = 700,
          JOP_A1 = 701,
          JOP_A2 = 702,
          JOP_A3 = 703,
          JOP_A4 = 704,
          JOP_B1 = 751,
          JOP_B2 = 752,
          JOP_B3 = 753,
          JOP_B4 = 753,
          JOP_5 = 705,
          JOP_6 = 706,
          JOP_7 = 707,
          JOP_8 = 708,
          JOP_9 = 709,
          JOP_10 = 710,
          JOP_11 = 711,
          JOP_12 = 712,
          JOP_13 = 713,
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
        OPDECODE_0: next_state = OPDECODE_1;
        OPDECODE_1: begin
                        // switch on op code
                        // for now lazy - see if loop works
                        if (irOp < 7) begin
                            next_state = ALUOP_0;
                        end else if (irOp == 7) begin
                            next_state = LDOP_0;
                        end else if (irOp == 8) begin
                            next_state = STOP_0;
                        end else if (irOp == 9) begin
                            next_state = JOP_0;
                        end else if (irOp == 10) begin
                            next_state = LIOP_0;
                        end else if (irOp > 10) begin
                            $finish;
                        end
                    end
        ALUOP_0:    next_state = ALUOP_1;
        ALUOP_1:    next_state = ALUOP_2;
        ALUOP_2:    next_state = ALUOP_3;
        ALUOP_3:    next_state = ALUOP_4;
        ALUOP_4:    next_state = ALUOP_5;
        ALUOP_5:    next_state = ALUOP_6;
        ALUOP_6:    next_state = ALUOP_7;
        ALUOP_7:    next_state = ALUOP_8;
        ALUOP_8:    next_state = ALUOP_9;
        ALUOP_9:    next_state = INCPC_0;
        LDOP_0:     next_state = LDOP_1;
        LDOP_1:     next_state = LDOP_2;
        LDOP_2:     next_state = LDOP_3;
        LDOP_3:     next_state = INCPC_0;
        STOP_0:     next_state = STOP_1;
        STOP_1:     next_state = STOP_2;
        STOP_2:     next_state = STOP_3;
        STOP_3:     next_state = STOP_4;
        STOP_4:     next_state = STOP_5;
        STOP_5:     next_state = INCPC_0;
        LIOP_0:     next_state = LIOP_1;
        LIOP_1:     next_state = LIOP_2;
        LIOP_2:     next_state = LIOP_3;
        LIOP_3:     next_state = LIOP_4;
        LIOP_4:     next_state = LIOP_5;
        LIOP_5:     next_state = LIOP_6;
        LIOP_6:     next_state = LIOP_7;
        LIOP_7:     next_state = LIOP_8;
        LIOP_8:     next_state = LIOP_9;
        LIOP_9:     next_state = LIOP_10;
        LIOP_10:    next_state = INCPC_0;
        JOP_0:      begin
                        // switch on value of reg 2
                        // for now lazy 
                        if (irReg2 == 0) begin
                            $finish;
                        end else if (irReg2 == 1) begin
                            next_state = JOP_B1;
                        end else begin
                            next_state = JOP_A1;
                        end
                    end
        JOP_A1:     next_state = JOP_A2;
        JOP_A2:     next_state = JOP_A3;
        JOP_A3:     next_state = JOP_A4;
        JOP_A4:     next_state = JOP_5;
        JOP_B1:     next_state = JOP_B2;
        JOP_B2:     next_state = JOP_B3;
        JOP_B3:     next_state = JOP_B4;
        JOP_B4:     next_state = JOP_5;
        JOP_5:      next_state = JOP_6;
        JOP_6:      next_state = JOP_7;
        JOP_7:      next_state = JOP_8;
        JOP_8:      next_state = JOP_9;
        JOP_9:      next_state = JOP_10;
        JOP_10:     next_state = JOP_11;
        JOP_11:     next_state = JOP_12;
        JOP_12:     begin
                        if (ir == 0) begin
                            next_state = JOP_13;
                        end else begin
                            next_state = INCPC_0;
                        end
                    end
        JOP_13:     next_state = INCPC_0;
        INCPC_0:    next_state = NEXTIR_0;
    endcase
end

//sequential
always @(posedge clk) begin
        PCBusMode <= 0;
        PCNext <= 0;
        PCReset <= 0;
        IRBusMode <= 0;
        //ALUOp <= 0;
        XBusMode <= 0;
        YBusMode <= 0;
        ZBusMode <= 0;
        //RegAddr <= 0;
        //regSel <= 0;
        RegMode <= 0;
        RegClear <= 0;
        MARBusMode <= 0;
        MDRBusMode <= 0;
        MDRMemMode <= 0;
        MemMode <= 0;
        ControlBusMode <= 0;
    if (reset == 1) begin
        state <= PCLOAD_0;
    end else begin
        state <= next_state;
        case (state)
            PCLOAD_0:   begin
                            PCReset <= 1;
                            //RegClear <= 1;
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
                            $display ("%h", ir);
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
                            XBusMode <= `BusRead;
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            ALUOP_2:    begin
                            XBusMode <= `BusRead;
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            ALUOP_3:    begin
                            YBusMode <= `BusRead;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            ALUOP_4:    begin
                            YBusMode <= `BusRead;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            ALUOP_5:    begin
                            YBusMode <= `BusRead;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            ALUOP_6:    begin
                            //Instruction op code
                            ALUOp <= irOp;
                        end
            ALUOP_7:    begin
                            ZBusMode <= `BusWrite;
                            regSel <= 1;
                            RegMode <= `regModeIn;
                        end
            ALUOP_8:    begin
                            ZBusMode <= `BusWrite;
                            regSel <= 1;
                            RegMode <= `regModeIn;
                        end
            ALUOP_9:    begin
                            ZBusMode <= `BusWrite;
                            regSel <= 1;
                            //RegMode <= `regModeIn;
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
            LDOP_3:     begin
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
                            MARBusMode <= `MARBusR;
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            STOP_2:     begin
                            MDRBusMode <= `MDRBusR;
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            STOP_3:     begin
                            MDRBusMode <= `MDRBusR;
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            STOP_4:     begin
                            MDRMemMode <= `MDRMemW;
                            MemMode <= `memModeIn;
                        end
            STOP_5:     begin
                            MDRMemMode <= `MDRMemW;
                            MemMode <= `memModeIn;
                        end
            LIOP_0:     begin
                            XBusMode <= `BusRead;
                            PCBusMode <= `PCBusW;
                        end
            LIOP_1:     begin
                            XBusMode <= `BusRead;
                            PCBusMode <= `PCBusW;
                        end
            LIOP_2:     begin
                            YBusMode <= `BusRead;
                            Bus <= 1;
                            ControlBusMode <= `BusWrite;
                        end
            LIOP_3:     begin
                            YBusMode <= `BusRead;
                            Bus <= 1;
                            ControlBusMode <= `BusWrite;
                        end
            LIOP_4:     begin
                            ALUOp <= `ALUadd;
                        end
            LIOP_5:     begin
                            ZBusMode <= `BusWrite;
                            MARBusMode <= `MARBusR;
                            PCBusMode <= `PCBusR;
                        end
            LIOP_6:     begin
                            ZBusMode <= `BusWrite;
                            MARBusMode <= `MARBusR;
                            PCBusMode <= `PCBusR;
                        end
            LIOP_7:     begin
                            MemMode <= `memModeOut;
                            MDRMemMode <= `MDRMemR;
                        end
            LIOP_8:     begin
                            MemMode <= `memModeOut;
                            MDRMemMode <= `MDRMemR;
                        end
            LIOP_9:     begin
                            regSel <= 1;
                            MDRBusMode <= `MDRBusW;
                            RegMode <= `regModeIn;
                        end
            LIOP_10:    begin
                            regSel <= 1;
                            MDRBusMode <= `MDRBusW;
                            RegMode <= `regModeIn;
                        end
            JOP_0:      begin
                            regSel <= 2;
                            RegMode <= `regModeOut;
                        end
            JOP_A1:     begin
                            regSel <= 2;
                            RegMode <= `regModeOut;
                            XBusMode <= `BusRead;
                        end
            JOP_A2:     begin
                            regSel <= 2;
                            RegMode <= `regModeOut;
                            XBusMode <= `BusRead;
                        end
            JOP_A3:     begin
                            Bus <= 16'hffff;
                            ControlBusMode <= `BusWrite;
                            YBusMode <= `BusRead;
                        end
            JOP_A4:     begin
                            Bus <= 16'hffff;;
                            ControlBusMode <= `BusWrite;
                            YBusMode <= `BusRead;
                        end
            JOP_B1:     begin
                            regSel <= 2;
                            RegMode <= 1;
                            XBusMode <= `BusRead;
                        end
            JOP_B2:     begin
                            regSel <= 2;
                            RegMode <= 1;
                            XBusMode <= `BusRead;
                        end
            JOP_B3:     begin
                            Bus <= 1;
                            ControlBusMode <= `BusWrite;
                            YBusMode <= `BusRead;
                        end
            JOP_B4:     begin
                            Bus <= 1;
                            ControlBusMode <= `BusWrite;
                            YBusMode <= `BusRead;
                        end
            JOP_5:      begin
                            ALUOp <= `ALUadd;
                            ZBusMode <= `BusWrite;
                        end
            JOP_6:      begin
                            ZBusMode <= `BusWrite;
                            MARBusMode <= `MARBusR;
                        end
            JOP_7:      begin
                            regSel <= 1;
                            RegMode <= `regModeOut;
                            //XBusMode <= `BusRead;
                        end
            JOP_8:      begin
                            regSel <= 1;
                            RegMode <= `regModeOut;
                        end
            JOP_9:      begin
                            XBusMode <= `BusRead;
                            IRBusMode <= `IRZR; 
                        end
            JOP_10:     begin
                            ALUOp <= `ALUany;
                            IRBusMode <= `IRZR; 
                        end
            JOP_11:     begin
                        end
            JOP_12:     begin
                            MARBusMode <= `MARBusW;
                        end
            JOP_13:     begin
                            PCBusMode <= `PCBusR;
                            MARBusMode <= `MARBusW;
                        end
        endcase
    end
end

always @(regSel or ir) begin
    if (regSel == 1) begin
        RegAddr = irReg1;
    end else  if (regSel == 2) begin
        RegAddr = irReg2;
    end
end
endmodule
