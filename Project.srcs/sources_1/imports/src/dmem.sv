`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// Contains the data memory (data that is stored and loaded by MIPS). This allows
// saving state by the computer and restoring state at a later time.
//
//////////////////////////////////////////////////////////////////////////////////

`include "memory.sv"
`include "initfile.sv"

module dmem (
    input clk,
    input mem_wr, 
    input [31:0] mem_addr, 
    input [31:0] mem_writedata, 
    output [31:0] mem_readdata
    );

    // Initialize Memory
    // Note we want to derive a word address so
    // mem_addr is shifted right by 2
    reg [`dmemDataBits-1:0] mem [`dmemLocation-1:0];
    initial $readmemh(`dmem_init, mem, 0, `dmemLocation - 1);
 
    // Allow Saving Data
    always_ff @(posedge clk)
        if(mem_wr)
            mem[{2'b00, mem_addr[31:2]}] <= mem_writedata;

    // Allow Reading Data
    assign mem_readdata = mem[{2'b00, mem_addr[31:2]}];

endmodule
