`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Montek Singh
// 4/6/2015 
//
//////////////////////////////////////////////////////////////////////////////////


module clockdivider_Nexys4(input clkin, output clk100, output clk50, output clk25, output clk12);

   MMCME2_BASE #(.CLKOUT0_DIVIDE_F(10), .CLKOUT1_DIVIDE(20), .CLKOUT2_DIVIDE(40), .CLKOUT3_DIVIDE(80),
            .CLKFBOUT_MULT_F(10), .CLKIN1_PERIOD(10.0)) 
            mmcm (.CLKOUT0(clkout0), .CLKOUT1(clkout1), .CLKOUT2(clkout2), .CLKOUT3(clkout3),
               .CLKFBOUT(clkfbout), .LOCKED(locked), .CLKIN1(clkin), .PWRDWN(1'b0),
               .RST(1'b0), .CLKFBIN(clkfbin));


   BUFG   bufclkfb (.I(clkfbout), .O(clkfbin));

   localparam N=2;
   reg [N:0] start_cnt=0;           // Count 2^N clock cycles of 100 MHz clock
   wire clock_enable=locked & start_cnt[N];  // Delay clock outputs by 2^N clock cycles of 100 MHz clock after lock
   always_ff @(posedge clkout0) begin
      if (locked & (start_cnt[N] != 1'b1))
         start_cnt <= start_cnt + 1'b1;
   end

   INV I1 (.I(clock_enable), .O(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf100 (.O(clk100), .I0(clkout0), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf50  (.O(clk50),  .I0(clkout1), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf25  (.O(clk25),  .I0(clkout2), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf12  (.O(clk12),  .I0(clkout3), .I1(1'b0), .S(not_clock_enable));
   
endmodule