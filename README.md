Pong
====

[Version 1.0.0 - 12/14/2015]

The following is a custom version of the classic arcade game Pong in System Verilog and built onto the Artix FPGA. 
This works via a custom ALU intended to process an arbitrary MIPS program with modified memory configuration:

* .text 0x0000
* .data 0x2000

I use a memory mapped IO scheme to draw to the monitor and interact with the keyboard. For demonstration purposes, 
included is a pong program (provided in samples/pong/pong.asm) written in MIPS which will run with the provided ALU 
once programmed onto the FPGA.

<p align="center">
<img src="https://raw.githubusercontent.com/jrpotter/pong/master/rsrc/demo.gif">
</p>
