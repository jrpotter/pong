`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2015 10:44:13 AM
// Design Name: 
// Module Name: screenmem
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

`include "memory.sv"
`include "initfile.sv"

module smem (
    input clk, input wr,
    input [`smemAddrBits-1:0] readaddr1,
    input [`smemAddrBits-1:0] readaddr2,
    input [`smemAddrBits-1:0] writeaddr,
    input [`smemDataBits-1:0] writedata,
    output [`smemDataBits-1:0] charcode1,
    output [`smemDataBits-1:0] charcode2
    );

    // Where screen memory is stored
    reg [`smemDataBits-1:0] mem [`smemLocation-1:0];
    initial $readmemh(`smem_init, mem, 0, `smemLocation - 1);
   
    // Memory write: only when wr==1, and only at posedge clock
    always_ff @(posedge clk)
        if(wr)
            mem[writeaddr] <= writedata; 
   
    // Returns the charcode which indexes bitmap memory
    assign charcode1 = mem[readaddr1];
    assign charcode2 = mem[readaddr2];

endmodule
