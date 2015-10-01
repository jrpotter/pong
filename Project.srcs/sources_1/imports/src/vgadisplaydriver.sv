`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// The display driver relates the memory mapped IO to the bitmap memory, and relays
// which color to display at which screen address.
//
//////////////////////////////////////////////////////////////////////////////////

`include "memory.sv"
`include "display640x480.sv"

module vgadisplaydriver (
    input clk,
    input [`smemDataBits-1:0] charcode,
    output hsync, vsync,
    output [3:0] red, green, blue,
    output [`smemAddrBits-1:0] smem_addr
    );
    
    // VGA Display
    // ===========================================
    // Loop through all columns and rows of the VGA display
    
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    
    vgatimer timer(clk, hsync, vsync, activevideo, x, y);
    
    
    // Screen Memory
    // ===========================================
    // Note the screen address corresponds to the index of the character being
    // accessed, and not necessarily the (x, y) pixel coordinates we are looking at
    
    assign smem_addr = (x >> `charWidthShift) + ((y >> `charHeightShift) * `charColCount);
    
    
    // Bitmap Memory
    // ===========================================
    // The bitmap character returned is the offset of the character given
    // by the current (x, y) coordinate
    
    wire [`bmemDataBits-1:0] color;
    wire [`bmemAddrBits-1:0] bmem_addr;
    
    assign bmem_addr = (`charSize * charcode) + (x % `charWidth + ((y % `charHeight) * `charWidth));
    bitmapmem bmem(bmem_addr, color);
        
        
    // Display Adapter
    // ===========================================
    // Note the Nexys 4 VGA adapter requires 4 bits of data for each
    // color component.
    
    assign red[3:0]   = (activevideo == 1) ? color[11:8] : 4'b0;
    assign green[3:0] = (activevideo == 1) ? color[7:4] : 4'b0;
    assign blue[3:0]  = (activevideo == 1) ? color[3:0] : 4'b0;


endmodule