// =======================================================================
//   Filename:     alu_test.v
//   Created by:   Tareque Ahmad
//   Date:         Feb 20, 2015
//
//   Description:  Test module for simple_alu dut
// =======================================================================

`timescale 1ns/1ps
`include "alu.pkg"

module alu_test
  (
   // Global inputs
   input clk,

   // Control outputs to the DUT
   output                    reset_n,
   output                    opcode_valid,
   output                    opcode,

   // Data output to the DUT
   output [DATA_WIDTH-1:0] data,

   // Responses from the DUT
   input                    done,
   input                    overflow,
   input  [DATA_WIDTH-1:0] result

   );

   // Define parameters
   parameter RESET_DURATION = 500;
   parameter CYCLE_TO_LATCH_FIRST_DATA = 2;
   //parameter OPCODE_ADD = 2'b00;
   //parameter OPCODE_SUB = 2'b01;
   //parameter OPCODE_PAR = 2'b10;
   //parameter OPCODE_COMP = 2'b11;

   // Define internal registers
   logic                   int_reset_n;
   logic                   int_opcode_valid;
   logic [1:0]             full_opcode;
   logic                   int_opcode;
   logic [DATA_WIDTH-1:0] int_data;
   int i;
   logic [3:0] delay;

   alu_test_stim_s stim;
   
   alu_test_stim_s alu_test_stim[0:15] =  {
        '{OPCODE_ADD,'0,'0,4'b0000},
        '{OPCODE_SUB,8'hff,8'h01,4'h1},
        '{OPCODE_PAR,8'haa,8'h55,4'h2},
        '{OPCODE_COMP,8'h55,8'haa,4'h3},
        '{OPCODE_ADD,8'h17,8'he8,4'h4},
        '{OPCODE_SUB,8'he8,8'h01,4'h5},
        '{OPCODE_PAR,8'h01,8'hc2,4'h6},
        '{OPCODE_COMP,8'hc2,8'h0f,4'h7},
        '{OPCODE_ADD,8'h0f,8'hf0,4'h8},
        '{OPCODE_SUB,8'hf0,8'h2c,4'h9},
        '{OPCODE_PAR,8'h2c,8'h7f,4'ha},
        '{OPCODE_COMP,8'h7f,8'h89,4'hb},
        '{OPCODE_ADD,8'h89,8'h3d,4'hc},
        '{OPCODE_SUB,8'h3d,8'h54,4'hd},
        '{OPCODE_PAR,8'h54,8'hf1,4'he},
        '{OPCODE_COMP,8'hf1,8'h0,4'hf}
   };

   //alu_test_stim_s test = {OPCODE_ADD,'0,'0,'0};

   initial
   begin
      // Generate one-time internal reset signal
      int_reset_n = 0;
      # RESET_DURATION int_reset_n = 1;
      $display ("\n@ %0d ns: The chip is out of reset", $time);

      int_opcode_valid = 0;

      repeat (5)  @(posedge clk);

      for (i=0; i < 16; i=i+1) begin
         $display ("\n@ %0d ns Starting new stimulus\n", $time);
         int_opcode_valid = 1;
         int_opcode = alu_test_stim[i].alu_opcode[0];
         int_data = alu_test_stim[i].data_a;
         $display("@ %0d: ns Valid Opcode = %h with Data A = %h is injected",$time,alu_test_stim[i].alu_opcode,int_data);
         repeat (CYCLE_TO_LATCH_FIRST_DATA) @(posedge clk);
         int_opcode = alu_test_stim[i].alu_opcode[1];
         int_data = alu_test_stim[i].data_b;
         $display("@ %0d: ns Valid Opcode = %h with Data B = %h is injected",$time,alu_test_stim[i].alu_opcode,int_data);
         while(done==0) @(posedge clk);
         $display ("@ %0d ns: Result is: %h. Overflow bit is %h.\n", $time, result, overflow);
         int_opcode_valid = 0;
         delay = alu_test_stim[i].delay;
         repeat (delay+2) @(posedge clk);
      end
      $finish;
   end
/*
   initial begin

      // Generate one-time internal reset signal
      int_reset_n = 0;
      # RESET_DURATION int_reset_n = 1;
      $display ("\n@ %0d ns: The chip is out of reset", $time);

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
*/
   // Continuous assignment to output
   assign reset_n      = int_reset_n;
   assign opcode_valid = int_opcode_valid;
   assign opcode       = int_opcode;
   assign data         = int_data;

endmodule //  alu_test

