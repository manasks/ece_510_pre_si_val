// =======================================================================
//   Filename:     alu_chkr.v
//   Created by:   Tareque Ahmad
//   Date:         April 20, 2014
//   ECE 510: Pre-Silicon Validation
//   Lab 1
//   This is the checker module meant to be used to check functionality
//   of simple_alu module done in Lab0
//
//   The rules for checking are as follows:
//   Check# 1: When reset_n is asserted (driven to 0),
//   all outputs become 0 within 1 clock cycle.
//
//   Check# 2: When opcode_valid is asserted, valid opcode 
//   and valid data (no X or Z) must be driven on the same cycle.
//
//   Check# 3: Output "done" must be asserted within 2 cycles 
//   after both valid data have been captured
//
//   Check# 4: Once "done" is asserted, output "result" must 
//   be correct on the same cycle.
//
//   Check# 5: Once "done" is asserted, output "overflow" must 
//   be correct on the same cycle
//
// =======================================================================

// Let's define some defines
`timescale 1ns/1ps
`include "alu.pkg"

module alu_chkr
  (
   // Global inputs
   input                     clk,
   input                     reset_n,

   // Control inputs
   input                     opcode_valid,
   input                     opcode,

   // Data inputs
   input [DATA_WIDTH-1:0]   data,

   // 
   input                    done,
   input                    overflow,
   input  [DATA_WIDTH-1:0] result

   );

   parameter OPCODE_ADD = 2'b00;
   parameter OPCODE_SUB = 2'b01;
   parameter OPCODE_PAR = 2'b10;
   parameter OPCODE_COMP = 2'b11;

   reg [2:0] opcode_valid_count;
   reg [2:0] reset_count;

   reg [DATA_WIDTH-1:0] calc_result;
   reg                   calc_overflow;

   reg [DATA_WIDTH-1:0] data_a;
   reg [DATA_WIDTH-1:0] data_b;
   reg [1:0] int_opcode;

   // Generate some counters
   always @(posedge clk) begin
      if (opcode_valid)
         opcode_valid_count = opcode_valid_count+1;
      else
         opcode_valid_count = 0;

      if (reset_n == 1)
         reset_count = 0;
      else if (reset_count <= 4)
         reset_count = reset_count+1;
      else
         reset_count = reset_count;
   end

   // Capture both data operands on subsequent cycles
   always @(posedge clk) begin
      if (opcode_valid_count == 0) begin
         data_a     = 0;
         data_b     = 0;
         int_opcode = 0;
      end 
      else if (opcode_valid_count == 1) begin
         data_a = data;
         int_opcode[0] = opcode;
      end

      else if (opcode_valid_count == 3) begin
         data_b = data;
         int_opcode[1] = opcode;
      end

   end

   `ifndef DISABLE_CHECK1
      // Code for Check# 1
      always @(posedge clk) begin
         if (reset_count == 3) begin
            if (done !== 0 | result !== 0 | overflow !== 0) begin
               $display ("\n@ %0d ns: ALU CHKR: Error: Outputs are not zero after an assertion of reset.", $time);
            end
         end
      end
   `endif

   `ifndef DISABLE_CHECK2
      // Code for Check# 2
      always @(posedge clk) begin
         if (opcode_valid) begin
            if (opcode !== 1'b0 && opcode !== 1'b1) begin
               $display ("\n@ %0d ns: ALU CHKR: Error: Invalid opcode is detected while opcode_valid is asserted.", $time);
            end

            if ((data[0] !== 0 && data[0] !== 1) ||
                (data[1] !== 0 && data[1] !== 1) ||
                (data[2] !== 0 && data[2] !== 1) ||
                (data[3] !== 0 && data[3] !== 1) ||
                (data[4] !== 0 && data[4] !== 1) ||
                (data[5] !== 0 && data[5] !== 1) ||
                (data[6] !== 0 && data[6] !== 1) ||
                (data[7] !== 0 && data[7] !== 1)) begin
               $display ("\n@ %0d ns: ALU CHKR: Error: Invalid data is detected while opcode_valid is asserted.", $time);
            end

            calc_outputs();
         end
      end
   `endif

   `ifndef DISABLE_CHECK3
      // Code for Check# 3
      always @(posedge clk) begin
         if (opcode_valid_count == 5) begin
            if (done !== 1) begin
               $display ("\n@ %0d ns: ALU CHKR: Error: Done is not set within two cycles of opcode_valid.", $time);
            end
         end
      end
   `endif

   `ifndef DISABLE_CHECK4
      // Code for Check# 4
      always @(posedge clk) begin
         if (opcode_valid_count == 5) begin
            if (result !== calc_result) begin
               $display ("\n@ %0d ns: ALU CHKR: Error: Result does not match with expected results.", $time);
               $display ("\n@ %0d ns: ALU CHKR: Error: Expected: %h. Actual: %h for opcode= %h , data_a= %h, data_b= %h", $time, calc_result, result, int_opcode, data_a, data_b);
            end
         end
      end
   `endif

   `ifndef DISABLE_CHECK5
      // Code for Check# 4
      always @(posedge clk) begin
         if (opcode_valid_count == 5) begin
            if (overflow !== calc_overflow) begin
               $display ("\n@ %0d ns: ALU CHKR: Error: Overflow does not match with expected overflow.", $time);
               $display ("\n@ %0d ns: ALU CHKR: Error: Expected: %h. Actual: %h for opcode= %h , data_a= %h, data_b= %h", $time, calc_overflow, overflow, int_opcode, data_a, data_b);
            end
         end
      end
   `endif

   // Task to calculate expected results
   task calc_outputs;
   begin
      case(int_opcode)
         OPCODE_ADD:   begin
                  {calc_overflow,calc_result} <= data_a + data_b;
               end

         OPCODE_SUB:   begin
                  {calc_overflow,calc_result} <= data_a - data_b;
               end

         OPCODE_PAR:   begin
                  calc_result   <= data_a ^ data_b;
                  calc_overflow <= ^calc_result;
               end

         OPCODE_COMP:   begin
                  calc_result   <= data_a ~^ data_b;
                  calc_overflow <= 0;
               end
      endcase
   end   
   endtask


endmodule //  alu_chkr

