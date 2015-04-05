module byte_comp(byte_a, byte_b, byte_comp, start, done);

parameter DATA_WIDTH = 8;

input [DATA_WIDTH-1:0] byte_a;
input [DATA_WIDTH-1:0] byte_b;
input start;

output [DATA_WIDTH-1:0] byte_comp;
output done;

genvar i;

generate
	for (i=0; i<DATA_WIDTH; i=i+1)
	begin:
		bit_comp bit_comp (
				.bit_a(byte_a[i]),
				.bit_b(byte_b[i]),
				.bit_comp(byte_comp[i]),
				.start(start),
				.done(done)
		);
    end
endgenerate

endmodule

