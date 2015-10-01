`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2015 05:06:21 AM
// Design Name: 
// Module Name: sext
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


module signExtension(
    input en,
    input [15:0] imm,
    output [31:0] signImm
    );
    
    assign signImm = en ? {{16{imm[15]}}, imm} : {{16{32'h00}}, imm};
    
endmodule
