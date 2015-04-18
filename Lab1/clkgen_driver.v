// =======================================================================
//   Filename:     clkgen_driver.v
//   Created by:   Tareque Ahmad
//   Date:         Feb 20, 2015
//
//   Description:  Clock generator module
// =======================================================================

`timescale 1ns/1ps

// Define module
module clkgen_driver
  (
   output clk
   );

   // Define parameters
   parameter CLOCK_PERIOD = 10;

   // Define internal registers
   reg int_clk;

   // Generate fixed frequency internal clock
   initial begin
      int_clk = 0;
      forever #(CLOCK_PERIOD/2) int_clk = ~int_clk;
   end

   // Continuous assignment to output
   assign clk     = int_clk;

endmodule

