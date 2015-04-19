`timescale 1ns/1ps

module top1();

wire clk_def;

parameter DATA_WIDTH = 8;
reg [4:0] checker_enable_reg = 5'b00100;

wire reset_n_wire;
wire opcode_valid_wire;
wire opcode_wire;
wire [DATA_WIDTH-1:0] data_wire;
wire done_wire;
wire [DATA_WIDTH-1:0] result_wire;
wire overflow_wire;

	clkgen_driver clkgen(
			.clk(clk_def)
	);

	simple_alu alu(
			.clk(clk_def),
			.reset_n(reset_n_wire),
			.opcode_valid(opcode_valid_wire),
			.opcode(opcode_wire),
			.data(data_wire),
			.done(done_wire),
			.result(result_wire),
			.overflow(overflow_wire)
	);
		
	alu_test #(DATA_WIDTH) test(
		.clk(clk_def),
		.reset_n(reset_n_wire),
		.opcode_valid(opcode_valid_wire),
		.opcode(opcode_wire),
		.data(data_wire),
		.done(done_wire),
		.overflow(overflow_wire),
		.result(result_wire)
    );

	alu_chkr #(DATA_WIDTH) chkr(
		.clk(clk_def),
		.reset_n(reset_n_wire),
		.opcode_valid(opcode_valid_wire),
		.opcode(opcode_wire),
		.data(data_wire),
		.result(result_wire),
		.overflow(overflow_wire),
		.done(done_wire),
		.checker_enable(checker_enable_reg)
	);

endmodule

