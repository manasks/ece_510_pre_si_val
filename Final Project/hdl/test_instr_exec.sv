`include "pdp8_pkg.sv"
import pdp8_pkg::*;

module top;

logic clk;
logic reset_n;
logic enable_stimulus;
logic [`ADDR_WIDTH-1:0] base_addr;
pdp_mem_opcode_s pdp_mem_opcode;
pdp_op7_opcode_s pdp_op7_opcode;
logic [`ADDR_WIDTH-1:0] PC_value;
logic [`ADDR_WIDTH-1:0] exec_wr_addr;
logic [`DATA_WIDTH-1:0] exec_wr_data;
logic [`ADDR_WIDTH-1:0] exec_rd_addr;
logic [`DATA_WIDTH-1:0] exec_rd_data;
logic stall;
logic exec_wr_req;
logic exec_rd_req;


bind instr_exec assertions_instr_exec bind_instr_exec(.*);

clkgen_driver #(.CLOCK_PERIOD(10), .RESET_DURATION(500)) clkgen_driver_inst (
	.clk     (clk),
	.reset_n (reset_n));

instr_exec instr_exec_inst(
        .clk(clk),
        .reset_n(reset_n),
        .base_addr(base_addr),
        .pdp_mem_opcode(pdp_mem_opcode),
        .pdp_op7_opcode(pdp_op7_opcode),
        .stall(stall),
        .PC_value(PC_value),
        .exec_wr_req(exec_wr_req),
        .exec_wr_addr(exec_wr_addr),
        .exec_wr_data(exec_wr_data),
        .exec_rd_req(exec_rd_req),
        .exec_rd_addr(exec_rd_addr),
        .exec_rd_data(exec_rd_data)
        );

stim_instr_exec stim_instr_inst(
        .clk(clk),
        .reset_n(reset_n),
        .enable_stimulus(enable_stimulus),
        .stall(stall),
        .pdp_mem_opcode(pdp_mem_opcode),
        .pdp_op7_opcode(pdp_op7_opcode)
        );

chkr_instr_exec chkr_instr_inst(.*);
resp_instr_exec resp_instr_inst(.*);

always @(posedge clk)
begin
    enable_stimulus=1'b0;
    if(reset_n)
    begin
        enable_stimulus=1'b1;
    end
end

endmodule
