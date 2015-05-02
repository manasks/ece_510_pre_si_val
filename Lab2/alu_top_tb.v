// =======================================================================
//   Filename:     alu_top_tb.v
//   Created by:   Tareque Ahmad
//   Date:         Feb 20, 2015
//
//   Description:  Top level testbench module for simple_alu
//                 and alu_test modules
// =======================================================================

`timescale 1ns/1ps
`include "alu.pkg"
`define DATA_WIDTH 8

module alu_top_tb ();

wire                    clk;
wire                    reset_n;

wire                    opcode_valid;
wire                    opcode;


wire  [`DATA_WIDTH-1:0] data;

wire                    done;
wire                    overflow;
wire  [`DATA_WIDTH-1:0] result;

alu_test alu_test(.clk          (clk),
                  .reset_n      (reset_n),
                  .opcode_valid (opcode_valid),
                  .opcode       (opcode),
                  .data         (data),
                  .done         (done),
                  .overflow     (overflow),
                  .result       (result));

clkgen_driver #(
   .CLOCK_PERIOD(10)) clkgen_driver (
   .clk     (clk));

simple_alu simple_alu(.clk          (clk),
                      .reset_n      (reset_n),
                      .opcode_valid (opcode_valid),
                      .opcode       (opcode),
                      .data         (data),
                      .done         (done),
                      .overflow     (overflow),
                      .result       (result));

alu_chkr alu_chkr(.clk          (clk),
                  .reset_n      (reset_n),
                  .opcode_valid (opcode_valid),
                  .opcode       (opcode),
                  .data         (data),
                  .done         (done),
                  .overflow     (overflow),
                  .result       (result));

endmodule
