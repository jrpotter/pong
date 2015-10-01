`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2015 04:24:30 AM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath #(
    parameter Abits = 5,          // Number of bits in address
    parameter Dbits = 32,         // Number of bits in data
    parameter Nloc = 32           // Number of memory locations
)(
    input clk,
    input reset,
    output reg [31:0] pc = 0,
    input [31:0] instr,
    input [1:0] pcsel,
    input [1:0] wasel,
    input sext,
    input bsel,
    input [1:0] wdsel,
    input [4:0] alufn,
    input werf,
    input [1:0] asel,
    output Z,
    output [31:0] mem_addr,
    output [31:0] mem_writedata,
    input [31:0] mem_readdata
);

    wire [4:0] shamt;
    wire [31:0] pcPlus4;
    wire [31:0] signImm;
    wire [31:0] J, JT, BT;
    wire [4:0] Rs, Rt, Rd;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] alu_result, aluA, aluB;
    wire [31:0] reg_writeaddr, reg_writedata;
   
   
    // Program Counter
    // =============================================
    
    assign pcPlus4 = pc + 4;
    
    always_ff @(posedge clk) begin
        if(reset) pc <= 0;
        else pc <= (pcsel == 2'b11) ? JT
                 : (pcsel == 2'b10) ? {pc[31:28], J, 2'b00}
                 : (pcsel == 2'b01) ? BT
                 : pcPlus4;
    end
    
    
    // Branching/Jumping
    // =============================================
    
    assign JT = ReadData1;
    assign J = instr[25:0];
    assign BT = pcPlus4 + (signImm << 2);
    
   
    // Register File
    // =============================================
    
    assign Rs = instr[25:21];
    assign Rt = instr[20:16];
    assign Rd = instr[15:11];
    assign reg_writeaddr = (wasel == 2'b00) ? Rd : (wasel == 2'b01) ? Rt : 31;
    assign reg_writedata = (wdsel == 2'b00) ? pcPlus4 : (wdsel == 2'b01) ? alu_result : mem_readdata;
   
    register_file #(Abits, Dbits, Nloc) rf(
        clk, werf, Rs, Rt, reg_writeaddr, 
        reg_writedata, ReadData1, ReadData2
        );
    
    
    // Sign Extension
    // =============================================
    
    signExtension signExt(sext, instr[15:0], signImm);
    
    
    // ALU
    // =============================================
   
    assign aluA = (asel == 2'b00) ? ReadData1 : (asel == 2'b01) ? shamt : 16;
    assign aluB = (bsel == 1'b0) ? ReadData2 : signImm;
    assign mem_writedata = ReadData2;
    assign mem_addr = alu_result;
    assign shamt = instr[10:6];
   
    ALU #(Dbits) alu(aluA, aluB, alufn, alu_result, Z);
    
    
endmodule
