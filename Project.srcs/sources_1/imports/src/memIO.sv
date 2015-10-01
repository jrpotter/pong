`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// Contains all memory mapped IO, including the screen, data memory, keyboard,
// input in general, and the memory mapper. It will relay the correct readdata
// out to the mips processor (as it must be able to distinguish between the
// different memories depending on the given address), and the character code
// for the VGA display adapter.
//
//////////////////////////////////////////////////////////////////////////////////

`include "memory.sv"
`include "display640x480.sv"

module memIO (
    input clk,
    input ps2_clk,
    input ps2_data,
    input mips_wr,
    input [31:0] mips_addr, 
    input [31:0] mips_writedata, 
    output [31:0] mips_readdata,
    input [`smemAddrBits-1:0] driver_addr,
    output [`smemDataBits-1:0] driver_readdata,
    output [7:0] segments, digitselect
    );
    
    // Wiring
    // ===========================================
    
    wire dmem_wr, dmem_active;
    wire [`dmemAddrBits-1:0] dmem_addr;
    wire [`dmemDataBits-1:0] dmem_readdata;
    wire [`dmemDataBits-1:0] dmem_writedata;
    
    wire smem_wr, smem_active;
    wire [`smemAddrBits-1:0] smem_addr;
    wire [`smemDataBits-1:0] smem_readdata;
    wire [`smemDataBits-1:0] smem_writedata;
    
    wire kmem_active;
    wire [`kmemDataBits-1:0] kmem_readdata;
    
    
    // Active Memory
    // ===========================================
    // Convenience wires determining which memory to read from and write to
    
    assign smem_active = (mips_addr >= `smemLow && mips_addr <= `smemHigh);
    assign dmem_active = (mips_addr >= `dmemLow && mips_addr <= `dmemHigh);
    assign kmem_active = (mips_addr == `kmemLow);
    
    
    // Addressing
    // ===========================================
    // This just requires offsetting the address by the base amount
    
    assign smem_addr = mips_addr - `smemLow;
    assign dmem_addr = mips_addr - `dmemLow;
    
    
    // Read Data
    // ===========================================
    // Determine which is read depending on the address location being accessed
    // Note charCode is a smaller bus than dmem_readdata, which has size equal mem_readdata
    // Returns the read data back to the MIPS processor
    
    assign mips_readdata = smem_active ? {{(`word-`smemDataBits){1'b0}}, smem_readdata} : 
                           dmem_active ? {{(`word-`dmemDataBits){1'b0}}, dmem_readdata} :
                           kmem_active ? {{(`word-`kmemDataBits){1'b0}}, kmem_readdata} :
                           32'h00000000;


    // Write Data
    // ===========================================          
    // Determines if writing out to screen or data (if at all)
    // Note the writedata should just be propagated to all other write datas
  
    assign dmem_wr = dmem_active ? mips_wr : 0;
    assign smem_wr = smem_active ? mips_wr : 0;
    
    
    // Keyboard Memory
    // ===========================================
    // Note the keyboard cannot be written to. It is merely read.
    
    keyboard kmem(clk, ps2_clk, ps2_data, kmem_readdata);
    display8digit disp(kmem_readdata, clk, segments, digitselect);
    
    
    // Screen Memory
    // ===========================================
    // Data to be displayed on the monitor. Note this has two ports
    // for reading (one for VGA driver and the other for MIPS accessing)
    // and one port for writing
    
    smem smem(.clk(clk), .wr(smem_wr), 
        .readaddr1(driver_addr), .readaddr2(smem_addr), 
        .writeaddr(smem_addr), .writedata(mips_writedata), 
        .charcode1(driver_readdata), .charcode2(smem_readdata));
        
    
    // Data Memory
    // ===========================================
    // Data to be loaded or written to
            
    dmem dmem(clk, dmem_wr, dmem_addr, mips_writedata, dmem_readdata);
    
    
endmodule
