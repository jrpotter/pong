`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2015 10:09:21 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter N=32) (
    input [N-1:0] A, B,
    input [4:0] ALUfn,
    output [N-1:0] R,
    output FlagZ
    );
    
    wire subtract, bool1, bool0, shft, math;
    assign {subtract, bool1, bool0, shft, math} = ALUfn[4:0];
    
    // Results from the three ALU components
    wire [N-1:0] addsubResult, shiftResult, logicalResult, compResult;
    
    addsub #(N) AS(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
    shifter #(N) S(B, A[4:0], ~bool1, ~bool0, shiftResult);
    logical #(N) L(A, B, {bool1, bool0}, logicalResult);
    comparator #(N) C(FlagN, FlagV, FlagC, bool0, compResult);
    
    assign R = (~shft & math) ? addsubResult :
               (shft & ~math) ? shiftResult :
               (~shft & ~math) ? logicalResult : compResult;
               
    assign FlagZ = (R == 0);
    
endmodule
