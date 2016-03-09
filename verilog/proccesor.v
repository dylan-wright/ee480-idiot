/*  
 *  EE480 - Assignment 2: The Making Of An IDIOT
 *  proccesor.v - top level module
 *  Version:
 *      03-02 : initial version
 *      03-03 : integrated ALU
 */

`include "signals.v"

module proccesor (
    input reset,
    input clk
    );

    //ALU registers and data lines
    reg `WORD X;
    reg `WORD Y;
    reg `WORD Z;
    wire [2:0] ALUop;
    wire `WORD z;

    //Register file datalines
    wire `WORD reg_data_out;
    reg `WORD reg_data_in;
    reg [5:0] reg_sel;
    reg [1:0] reg_mode;
    reg reg_clear;

    //Memory registers and data lines
    wire `WORD mem_data_out;
    reg `WORD mem_data_in;
    reg [1:0] mem_mode;
    reg `WORD mem_address;  //MAR

    //other registers
    reg `WORD ir;
    reg `WORD pc;
    reg `WORD Bus;
    reg `WORD mdr;

    //control lines
    wire PCInc, PCNext, PCReset;
    wire [1:0] PCBusMode, IRBusMode, XBusMode, YBusMode, ZBusMode,
               RegMode, MARBusMode, MDRBusMode, MDRMemMode, MemMode;
    wire [5:0] RegSel;
    wire `WORD bus;
    //Module instantiation
    alu alu_mod(X,
                Y,
                ALUop,
                z);
    register_file register_file_mod(reg_data_out,
                                    reg_data_in,
                                    reg_sel,
                                    reg_mode,
                                    clk,
                                    reg_clear);
    memory memory_mod(mem_data_out,
                      mem_data_in,
                      mem_mode,
                      mem_address,
                      clk);
    control control_mod(clk,
                        reset,
                        bus,
                        PCBusMode,
                        PCNext,
                        PCReset,
                        ir,
                        IRBusMode,
                        ALUop,
                        XBusMode,
                        YBusMode,
                        ZBusMode,
                        RegSel,
                        RegMode,
                        MARBusMode,
                        MDRBusMode,
                        MDRMemMode,
                        MemMode);

    always @(posedge clk)
    begin
        mem_mode <= MemMode;
        
        Z <= z;

        if (MARBusMode == `MARBusW) begin
            Bus <= mdr;
        end 

        if (PCReset == 1) begin
            pc <= 0;
        end

        
        if (PCNext == 1) begin
            pc <= pc + 1;
        end

        if (PCBusMode == `PCBusW) begin
            Bus <= pc;
        end 

        if (IRBusMode == `IRBusW) begin
            Bus <= ir;
        end 

        if (MARBusMode == `MARBusW) begin
            Bus <= mem_address;
        end 

        if (MDRBusMode == `MDRBusW) begin
            Bus <= mdr;
        end 

        if (MDRMemMode == `MDRMemR) begin
            mdr <= mem_data_out;
        end

        if (XBusMode == `BusWrite) begin
            Bus <= X;
        end 

        if (YBusMode == `BusWrite) begin
            Bus <= Y;
        end 

        if (ZBusMode == `BusWrite) begin
            Bus <= Z;
        end
    end
    always @(negedge clk) begin

        
        if (MARBusMode == `MARBusR) begin
            mdr <= Bus;
        end

        if (PCBusMode == `PCBusR) begin
            pc <= Bus;
        end 

        // This is a hacky way but it works.
        // ir SHOULD only ever read from mdr so skip the slow dumb bus
        if (IRBusMode == `IRBusR) begin
            ir <= mdr;
        end

        if (MARBusMode == `MARBusR) begin
            mem_address <= Bus;
        end
        
        if (MDRBusMode == `MDRBusR) begin
            mdr <= Bus;
        end

        if (XBusMode == `BusRead) begin
            X <= Bus;
        end

        if (YBusMode == `BusRead) begin
            Y <= Bus;
        end

        if (ZBusMode == `BusRead) begin
            Z <= Bus;
        end
    end
endmodule
