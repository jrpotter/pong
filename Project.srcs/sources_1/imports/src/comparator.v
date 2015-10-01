`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2015 11:21:19 AM
// Design Name: 
// Module Name: comparator
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


module comparator #(parameter N=32) (
    input FlagN, FlagV, FlagC,
    input bool0,
    output [N-1:0] comparison
    );
    
    assign c = bool0 ? (~FlagC) : (FlagN ^ FlagV);
    assign comparison = {{(N-1){1'b0}}, c};
    
endmodule
