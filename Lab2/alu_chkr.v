`timescale 1ns/1ps
`include "alu.pkg"
`define DISABLE_CHECKER1
`define DISABLE_CHECKER2
`define DISBALE_CHECKER3
`define DISABLE_CHECKER4
`define DISABLE_CHECKER5

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

   // Checker #1
   `ifndef DISABLE_CHECK1
   property reset_n_p;
     @(posedge clk)
        (~reset_n) |=> (result == '0 && overflow == '0 && done =='0);
   endproperty
   reset_n_a: assert property(reset_n_p);
   `endif

   // Checker #2
   `ifndef DISABLE_CHECK2
   property valid_p;
     @(posedge clk)
        (opcode_valid) |-> ((opcode !== 'x && data !== 'x) | (opcode !== 'z && data !== 'z));
   endproperty
   valid_a: assert property(valid_p);
   `endif

   // Checker #3
   `ifndef DISABLE_CHECK3
   property done_p;
     @(posedge clk)
         (opcode_valid_count == 4) |-> (done);
   endproperty
   done_a: assert property(done_p);
   `endif

   // Checker #4
   `ifndef DISABLE_CHECK4
   property result_p;
     @(posedge clk)
        (done)  |-> (result == calc_result);
   endproperty
   result_a: assert property(result_p);
   `endif

   // Checker #5
   `ifndef DISABLE_CHECK5
   property overflow_p;
     @(posedge clk)
        (done)  |=> (overflow == calc_overflow);
   endproperty
   overflow_a: assert property(overflow_p);
   `endif

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
      $display();
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
         calc_outputs();
      end
   end

   // Task to calculate expected results
   task calc_outputs;
   begin
      case(int_opcode)
         OPCODE_ADD:   begin
                  {calc_overflow,calc_result} = data_a + data_b;
               end

         OPCODE_SUB:   begin
                  {calc_overflow,calc_result} = data_a - data_b;
               end

         OPCODE_PAR:   begin
                  calc_result   = data_a ^ data_b;
                  calc_overflow <= 0;
               end

         OPCODE_COMP:   begin
                  calc_result   = data_a ^~ data_b;
                  calc_overflow = 0;
               end
      endcase
   end   
   endtask


endmodule //  alu_chkr

