`timescale 1ns/1ps
`include "alu.pkg"
module byte_parity(byte_a, byte_b, byte_parity, start, done);

input [DATA_WIDTH-1:0] byte_a;
input [DATA_WIDTH-1:0] byte_b;
input start;

output [DATA_WIDTH-1:0] byte_parity;
output done;

//assign byte_parity = byte_a ^ byte_b;
//assign done = start;

genvar i;

generate
	for (i=0; i<DATA_WIDTH; i=i+1)
	begin
		bit_parity parity (
				.bit_a(byte_a[i]),
				.bit_b(byte_b[i]),
				.bit_parity_out(byte_parity[i]),
				.start(start),
				.done(done)
		);
    end
endgenerate

endmodule
