`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 3/26/2015 
//
//////////////////////////////////////////////////////////////////////////////////

module mips(
    input clk, 
    input reset, 
    output [31:0] pc, 
    input [31:0] instr, 
    output mem_wr, 
    output [31:0] mem_addr,
    output [31:0] mem_writedata, 
    input [31:0] mem_readdata
    );
    
    wire [1:0] pcsel, wdsel, wasel;
    wire [4:0] alufn;
    wire Z, sext, bsel, dmem_wr, werf;
    wire [1:0] asel; 

    controller c(.op(instr[31:26]), .func(instr[5:0]), .Z(Z),
                   .pcsel(pcsel), .wasel(wasel[1:0]), .sext(sext), .bsel(bsel), 
                   .wdsel(wdsel), .alufn(alufn), .wr(mem_wr), .werf(werf), .asel(asel));

    datapath #(5, 32, 32) dp(.clk(clk), .reset(reset), 
                   .pc(pc), .instr(instr),
                   .pcsel(pcsel), .wasel(wasel[1:0]), .sext(sext), .bsel(bsel), 
                   .wdsel(wdsel), .alufn(alufn), .werf(werf), .asel(asel),
                   .Z(Z), .mem_addr(mem_addr), .mem_writedata(mem_writedata), .mem_readdata(mem_readdata));

endmodule