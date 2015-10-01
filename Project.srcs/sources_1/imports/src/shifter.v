`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2015 09:43:36 PM
// Design Name: 
// Module Name: shifter
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


module shifter #(parameter N=32) (
    input signed [N-1:0] IN,
    input [$clog2(N)-1:0] shamt, // ceiling log base 2
    input left, input logical,
    output [N-1:0] OUT
    );
    
    assign OUT = left ? (IN << shamt) :
                    (logical ? IN >> shamt : IN >>> shamt);
    
endmodule
