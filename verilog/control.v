`include "signals.v"

module control(
    clk,
    reset,
    PCBusMode,
    PCNext,
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

output PCBusMode;
output PCNext;

input `WORD ir;
output IRBusMode;

output [2:0] ALUOp;
output [1:0] XBusMode;
output [1:0] YBusMode;
output [1:0] ZBusMode;

output [5:0] RegAddr;
output [1:0] RegMode;

output [1:0] MARBusMode;
output [1:0] MDRBusMode;
output [1:0] MDRMemMode;
output [1:0] MemMode;

//internals
reg `WORD state, next_state;

//State def
parameter PCLOAD_0 = 0,
          NEXTIR_0 = 100,
          NEXTIR_1 = 101,
          NEXTIR_2 = 102,
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
          JOP_A3 = 703,
          JOP_A4 = 704,
          JOP_B1 = 751,
          JOP_B2 = 752,
          JOP_B3 = 753,
          JOP_B4 = 754,
          JOP_5 = 705,
          JOP_6 = 706,
          JOP_7 = 707,
          JOP_8 = 708,
          INCPC_0 = 800;

//combinational
always @(state) begin
    
end

//sequential
always @(posedge clk) begin

end
endmodule
