`timescale 1ns/1ps
`define DATA_WIDTH 8

module top();

reg [4:0] checker_enable_reg = 5'b11111;

wire reset_n_wire;
wire opcode_valid_wire;
wire opcode_wire;
wire [`DATA_WIDTH-1:0] data_wire;
wire done_wire;
wire [`DATA_WIDTH-1:0] result_wire;
wire overflow_wire;
wire clk_wire;

reg int_clk;

initial
begin
    int_clk = 0;
end

always @(posedge clk_wire)
begin
    int_clk = ~int_clk;
end

always @(posedge clk_wire)
begin
    //$display("");
end

	clkgen_driver clkgen(
			.clk(clk_wire)
	);

	simple_alu alu(
			.clk(clk_wire),
			.reset_n(reset_n_wire),
			.opcode_valid(opcode_valid_wire),
			.opcode(opcode_wire),
			.data(data_wire),
			.done(done_wire),
			.overflow(overflow_wire),
			.result(result_wire)
			
	);
		
	alu_test test(
		.clk(clk_wire),
		.reset_n(reset_n_wire),
		.opcode_valid(opcode_valid_wire),
		.opcode(opcode_wire),
		.data(data_wire),
		.done(done_wire),
		.overflow(overflow_wire),
		.result(result_wire)
    );

	alu_chkr chkr(
		.clk(int_clk),
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

