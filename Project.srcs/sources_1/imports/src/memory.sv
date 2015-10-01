//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// All definitions revolving around memories (or possibly memory mapped IOs).
//
//////////////////////////////////////////////////////////////////////////////////


// MIPs Architecture
// ===========================================
// MIPs works via a 32-bit word. All instructions, results, etc.
// must be aligned on a word (and probably sign extended to 32 bits)

`define word 32

// Starting and ending addresses of memory sections as defined by
// the MARS assembler.

`define dmemLow      32'h0000_2000
`define dmemHigh     32'h0000_3FFF
`define smemLow      32'h0000_4000
`define smemHigh     32'h0000_4FFF
`define kmemLow      32'h0000_6000


// Instruction Memory
// ===========================================

`define imemAddrBits 32
`define imemDataBits 32
`define imemLocation 256


// Data Memory
// ===========================================

`define dmemAddrBits 32
`define dmemDataBits 32
`define dmemLocation 32


// Screen Properties
// ===========================================

`define smemDataBits 8
`define smemAddrBits $clog2(`smemLocation)
`define smemLocation 1200


// Bitmap Properties
// ===========================================
// Note data bits need to be 12 since RGB is 12 bits long
// and locations is (`charWidth * `charHeight * `charUniqueCount)

`define bmemDataBits 12
`define bmemAddrBits $clog2(`bmemLocation)
`define bmemLocation 1280


// Keyboard Properties
// ===========================================
// Note the keyboard's address bit just needs to be greater than `kmemLow

`define kmemDataBits 24
