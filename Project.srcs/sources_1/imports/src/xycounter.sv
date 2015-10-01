`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2015 02:32:38 PM
// Design Name: 
// Module Name: xycounter
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


module xycounter #(parameter width=2, height=2) (
    input clock,
    input enable,
    output reg [$clog2(width)-1:0] x = 0,
    output reg [$clog2(height)-1:0] y = 0
    );
    
    always_ff @(posedge clock) begin
        if(enable) begin
            if(x + 1 == width) begin
                x <= 0;
                y <= (y + 1 == height) ? 0 : y + 1;
            end else begin
                x <= x + 1;
            end
        end
    end
    
endmodule
