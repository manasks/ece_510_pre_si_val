`timescale 1ns/1ps

module top();

reg clk_def;

parameter DATA_WIDTH = 8;

initial 
begin 
	clk_def = 0; 
end 
 
always
begin
    #10 clk_def = !clk_def; 
end

wire reset_n_wire;
wire opcode_valid_wire;
wire opcode_wire;
wire [DATA_WIDTH-1:0] data_wire;
wire done_wire;
wire [DATA_WIDTH-1:0] result_wire;
wire overflow_wire;

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


endmodule

