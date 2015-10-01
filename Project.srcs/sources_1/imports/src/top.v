`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter (Revised from Montek Singh)
// 3/26/2015
//
// This is the topmost module that ties all IO devices with the MIPs processor.
// It allows mips assembly code (hex dumped by the MARs assembler for example)
// to be run.
//
// Note when writing code, screen memory is at 0x00004000 and data memory is
// at 0x00002000, so store data at these locations for expected changes to occur.
//
//////////////////////////////////////////////////////////////////////////////////

`include "memory.sv"
`include "initfile.sv"
`include "display640x480.sv"

module top (
    input clk, reset,
    input ps2_clk, ps2_data,
    output hsync, vsync,
    output [3:0] red, green, blue,
    output [7:0] segments, digitselect
    );

    // Wiring
    // ===========================================
   
    // Instruction Memory & MIPS
    wire mem_wr, c_reset;
    wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
    
    // Memory IO
    wire [`smemDataBits-1:0] charcode;
    wire [`smemAddrBits-1:0] smem_addr;
    
    // Clocks
    wire clk100, clk50, clk25, clk12;
    
    
    // Clocking
    // ===========================================
    
    // Uncomment *only* one of the following two lines:
    //    when synthesizing, use the first line
    //    when simulating, get rid of the clock divider, and use the second line
    clockdivider_Nexys4 clkdv(clk, clk100, clk50, clk25, clk12);
    //assign clk100=clk; assign clk50=clk; assign clk25=clk; assign clk12=clk;
    
    
    // Instruction Storage
    // ===========================================
    // Instructions will be stored at 0x0000 and data stored at 0x2000
    // This happens with the MARS assembler set at "Compact, Text at 0"
    
    imem imem(pc, instr);
    
    
    // MIPS
    // ===========================================
    // Processes the instructions stored in the instruction memory.
    // Note the reset is high if the button is UP, not when it is down.
    // So we must invert this; during simulations we then set reset to high
    
    // We modify the debouncer slightly. If simulating, maintain an inversion
    // of 0. Otherwise, set inversion to 1 (since reset is high when depressed).
    //debouncer rbouncer(reset, clk12, 0, c_reset);
    debouncer rbouncer(reset, clk12, 1, c_reset);
    
    mips mips(.clk(clk12), .reset(c_reset), .pc(pc), 
        .instr(instr), .mem_wr(mem_wr), .mem_addr(mem_addr), 
        .mem_writedata(mem_writedata), .mem_readdata(mem_readdata));
        
    
    // Memory IO
    // ===========================================
    // Takes in the MIPS instruction and writes to data and memory
    // Also takes in a screen address and returns a character code
    // to be displayed at the corresponding address
    
    memIO io(.clk(clk12), .ps2_clk(ps2_clk), .ps2_data(ps2_data),
        .mips_wr(mem_wr), .mips_addr(mem_addr), 
        .mips_writedata(mem_writedata), .mips_readdata(mem_readdata), 
        .driver_addr(smem_addr), .driver_readdata(charcode),
        .segments(segments), .digitselect(digitselect));


    // VGA Display Driver
    // ===========================================
    // These contain bitmap information (which is readonly) and outputs color
    // based on the given character from memory IO
    
    vgadisplaydriver displaydriver(
        .clk(clk100), .charcode(charcode), .hsync(hsync), .vsync(vsync), 
        .red(red), .green(green), .blue(blue), .smem_addr(smem_addr));


endmodule