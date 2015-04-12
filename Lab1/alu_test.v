// =======================================================================
//   Filename:     alu_test.v
//   Created by:   Tareque Ahmad
//   Date:         April 11, 2015
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
   reg [7:0]  i;
   reg [15:0] j;
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

         for (j=0; j < 32767; j=j+1) begin

            $display ("\n@ %0d ns Starting test sequnce number %0d with opcode %h\n", $time,j,full_opcode);
            // Test sequence 1
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 2
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 3
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 4
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 5
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 6
            int_opcode_valid = 0;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 7
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 8
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            int_reset_n = 0;
            @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            int_reset_n = 1;

            repeat (5)  @(posedge clk);

            // Test sequence 9
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 10
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode_valid = 0;
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

            // Test sequence 11
            int_opcode_valid = 1;
            int_opcode = full_opcode[0];
            int_data = ({$random} % 8'hff);
            repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
            int_opcode = full_opcode[1];
            int_data = ({$random} % 8'hff);
            while (done == 0) @(posedge clk);
            int_opcode_valid = 0;
            delay = ({$random} % 4'hf);
            repeat (delay+2)  @(posedge clk);

         end

      end

      $finish;

   end

   // Continuous assignment to output
   assign reset_n      = int_reset_n;
   assign opcode_valid = int_opcode_valid;
   assign opcode       = int_opcode;
   assign data         = int_data;

endmodule //  alu_test

