`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Joshua Potter
// 4/15/2015
//
// Since button presses may bounce, we ensure the value emitted doesn't osscilate
// too rapidly. If it stays the same for a long enough time (as described below),
// we retain the button value as either pressed or released.
//
//////////////////////////////////////////////////////////////////////////////////


module debouncer(
    input raw,
    input clk,
    input invert,
    output clean
    );
    
    // Set N for debounce duration of 10ms
    // Since clock runs at 100 MHz or 10^8 cycles per second
    // So then it runs 10^6 cycles per 10 ms ~ 2^20.
    localparam N = 20;
    reg [N:0] count;
    
    // Used to hold clean value before inversion
    reg tmp_clean = 0;
    always_ff @(posedge clk) begin
        count <= (raw != tmp_clean) ? count + 1 : 0;
        tmp_clean <= (count[N] == 1) ? raw : tmp_clean;
    end
    
    // Allows inversion (for when simulating and actually running)
    assign clean = tmp_clean ^ invert;
    
endmodule
