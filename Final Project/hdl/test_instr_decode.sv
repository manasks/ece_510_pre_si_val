//Test bench module. This calls two important modules. They are Checker and Stimulus module. The Stimulus module gives stimulus and also acts as a responder. Checker module is used to check the validness of the outputs.


`include "pdp8_pkg.sv"
import pdp8_pkg::*;

module test_instr_decode(
   input clk,
   input reset_n,

   // From Execution unit
   output reg stall,
   output reg [`ADDR_WIDTH-1:0] PC_value,

   // To memory unit
   input                    ifu_rd_req,
   input  [`ADDR_WIDTH-1:0] ifu_rd_addr,

   // From memory unit
   output reg [`DATA_WIDTH-1:0] ifu_rd_data,
    input [`ADDR_WIDTH-1:0] base_addr,
	
	//From the DUT
    input pdp_mem_opcode_s pdp_mem_opcode,
    input pdp_op7_opcode_s pdp_op7_opcode
);

//Instantiating  the checker module
chkr_instr_decode chkr_instr_decode(.clk(clk),
	.reset_n(reset_n),
	.stall(stall),
	.PC_value(PC_value),
	.ifu_rd_req(ifu_rd_req),
    .ifu_rd_addr(ifu_rd_addr),
	.ifu_rd_data(ifu_rd_data),
    .base_addr(base_addr),
	.pdp_mem_opcode(pdp_mem_opcode),
 	.pdp_op7_opcode(pdp_op7_opcode));


//Instantiating the Stimulus/Responder module
stim_instr_decode stim_instr_decode_a (.clk(clk),
	.stall(stall),
	.PC_value(PC_value),
	.ifu_rd_req(ifu_rd_req),
	.ifu_rd_addr(ifu_rd_addr),
	.ifu_rd_data(ifu_rd_data));



endmodule