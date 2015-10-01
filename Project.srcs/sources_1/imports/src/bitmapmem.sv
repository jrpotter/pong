`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// The bitmap memory is a read only memory that relays the color of each pixel
// in a character to be displayed on the screen.
//
//////////////////////////////////////////////////////////////////////////////////

`include "memory.sv"
`include "initfile.sv"
`include "display640x480.sv"

module bitmapmem (
    input [`bmemAddrBits-1:0] addr,
    output [`bmemDataBits-1:0] color
    );

    // Where bitmap memory is stored
    reg [`bmemDataBits-1:0] mem [`bmemLocation-1:0];
    initial $readmemh(`bmem_init, mem, 0, `bmemLocation - 1);
    
    // Note the bitmap memory is readonly
    assign color = mem[addr];

endmodule
