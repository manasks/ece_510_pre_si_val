// =======================================================================
//   Filename:     alu_test.v
//   Created by:   Tareque Ahmad
//   Date:         Feb 20, 2015
//
//   Description:  Test module for simple_alu dut
// =======================================================================

`timescale 1ns/1ps

`define DATA_WIDTH 8

module alu_test
  (
   // Global inputs
   input clk,

   // Control outputs to the DUT
   output                    reset_n,
   output                    opcode_valid,
   output                    opcode,

   // Data output to the DUT
   output [`DATA_WIDTH-1:0] data,

   // Responses from the DUT
   input                    done,
   input                    overflow,
   input  [`DATA_WIDTH-1:0] result

   );

   // Define parameters
   parameter RESET_DURATION = 500;
   parameter CYCLE_TO_LATCH_FIRST_DATA = 2;
   parameter OPCODE_ADD = 2'b00;
   parameter OPCODE_SUB = 2'b01;
   parameter OPCODE_PAR = 2'b10;
   parameter OPCODE_COMP = 2'b11;

   // Define internal registers
   reg                   int_reset_n;
   reg                   int_opcode_valid;
   reg [1:0]             full_opcode;
   reg                   int_opcode;
   reg [`DATA_WIDTH-1:0] int_data;
   reg [7:0] i;
   reg [3:0] delay;

   initial begin

      // Generate one-time internal reset signal
      int_reset_n = 0;
      # RESET_DURATION int_reset_n = 1;
      $display ("\n@ %0d ns The chip is out of reset", $time);

      int_opcode_valid = 0;

      repeat (5)  @(posedge clk);

      // Start test code
      for (i=0; i < 4; i=i+1) begin

         case (i)
            0: full_opcode = OPCODE_ADD;
            1: full_opcode = OPCODE_SUB;
            2: full_opcode = OPCODE_PAR;
            3: full_opcode = OPCODE_COMP;
            default: $display ("Error; Invalid opcode \n");
         endcase

         $display ("\n@ %0d ns Starting sequnces with a new opcode\n", $time);
         // Test sequence 1
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'h00;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'h00;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 2
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'hFF;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'hFF;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 3
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'hAA;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'h55;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 4
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'h00;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'hFF;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 5
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'hFF;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'h01;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 6
         int_opcode_valid = 0;
         int_opcode = full_opcode[0];
         int_data = 8'hAA;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected without opcode_valid", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'h55;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected without opcode_valid", $time, full_opcode, int_data);
         @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 7
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'h20;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'hDF;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 8
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'hFF;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'h01;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         int_reset_n = 0;
         $display ("@ %0d ns: Reset is asserted", $time);
         @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         int_reset_n = 1;
         $display ("@ %0d ns: Reset is de-asserted \n", $time);

         repeat (5)  @(posedge clk);

         // Test sequence 9
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'h33;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'h5C;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 10
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'h98;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode_valid = 0;
         int_opcode = full_opcode[1];
         int_data = 8'h6B;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

         // Test sequence 11
         int_opcode_valid = 1;
         int_opcode = full_opcode[0];
         int_data = 8'hC2;
         $display ("@ %0d ns: Valid Opcode = %h with Data_A= %h is injected", $time, full_opcode, int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = full_opcode[1];
         int_data = 8'hE3;
         $display ("@ %0d ns: Valid Opcode = %h with Data_B= %h is injected", $time, full_opcode, int_data);
         while (done == 0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = ({$random} % 4'hf);
         repeat (delay+2)  @(posedge clk);

      end

      $finish;

   end

   // Continuous assignment to output
   assign reset_n      = int_reset_n;
   assign opcode_valid = int_opcode_valid;
   assign opcode       = int_opcode;
   assign data         = int_data;

endmodule //  alu_test

