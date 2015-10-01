# Pong
Pong written with custom ALU in Artix FPGA

The following is an implementation of an ALU in a FPGA designed to run arbitrary MIPS programs with a modified memory 
configuration where .text is at 0x0000 and .data is at 0x2000. I use a memory mapped IO scheme to draw to the monitor
and interact with the keyboard.

For demonstration purposes, included is a pong program (provided in samples/pong/pong.asm) written in MIPS which will run
with the provided ALU once programmed onto an FPGA.
