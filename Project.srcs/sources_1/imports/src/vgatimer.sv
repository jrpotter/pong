`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// Travels through each pixel in the VGA display, and properly emits horizontal
// and vertical pulses (as well as the active video) at approximately 25 MHz
// (given a 640x480 display).
//
//////////////////////////////////////////////////////////////////////////////////

`include "display640x480.sv"

module vgatimer(
    input clk,
    output hsync, vsync, activevideo,
    output [`xbits-1:0] x,
    output [`ybits-1:0] y
    );
    
    // These lines allow you to count every 2nd clock tick and 4th clock tick
    // This is because, depending on the display mode, we may need to count at 50 MHz or 25 MHz.
    reg [1:0] clk_count=0;
    always_ff @(posedge clk)
        clk_count <= clk_count + 2'b01;
        
    assign Every2ndTick = (clk_count[0] == 1'b1);
    assign Every4thTick = (clk_count[1:0] == 2'b11);
    
    // This part instantiates an xy-counter using the appropriate clock tick counter
    // xycounter #(`WholeLine, `WholeFrame) xy(clk, Every2ndTick, x, y); // Count at 50 MHz
    xycounter #(`WholeLine, `WholeFrame) xy(clk, Every4thTick, x, y); // Count at 25 MHz
    
    // Generate the monitor sync signals
    assign hsync = (x >= `hSyncStart && x <= `hSyncEnd) ? ~`hSyncPolarity : `hSyncPolarity;
    assign vsync = (y >= `vSyncStart && y <= `vSyncEnd) ? ~`vSyncPolarity : `vSyncPolarity;
    assign activevideo = (x < `hVisible && y < `vVisible);  
    
endmodule
