module top();

reg clk;

initial 
begin 
	clk = 0; 
end 
 
always
begin
    #10 clk = !clk; 
end

wire reset_n_wire;
wire opcode_valid_wire;
wire opcode_wire;
wire [DATA_WIDTH-1:0] data_wire;
wire done_wire;
wire [DATA_WIDTH-1:0] result_wire;
wire overflow_wire;

	simple_alu alu(
			.clk(clk),
			.reset_n(reset_n_wire),
			.opcode_valid(opcode_valid_wire),
			.opcode(opcode_wire),
			.data(data_wire),
			.done(done_wire),
			.result(result_wire),
			.overflow(overflow_wire)
	);
		
	alu_test test(
		clk(clk),
		reset_n(reset_n_wire),
		opcode_valid(opcode_valid_wire),
		opcode(opcode_wire),
		data(data_wire),
		done(done_wire),
		overflow(overflow_wire),
		result(result_wire)
    );


endmodule

