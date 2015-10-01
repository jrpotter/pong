`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// Contains the instructions (hex dumped by the MARS assembler probably). Note this
// is also a readonly memory. In addition, word addresses are accessed so we shift
// the program counter by 2 bits (since every 4 count corresponds to a word)
//
//////////////////////////////////////////////////////////////////////////////////

`include "memory.sv"
`include "initfile.sv"

module imem (
   input [31:0] pc,
   output [31:0] instr
);
 
   // Initialize Memory
   reg [`imemDataBits-1:0] mem [`imemLocation-1:0];
   initial $readmemh(`imem_init, mem, 0, `imemLocation - 1);
   
   // Return the instruction at PC
   // Note we want to derive a word address so shift right by 2
   assign instr = mem[{2'b00, pc[31:2]}];
 
endmodule
