module byte_comp(byte_a, byte_b, byte_comp, start, done)

parameter comp_size = 8;

input [comp_size-1] byte_a;
input [comp_size-1] byte_b;
input byte_borrow_in;

output [comp_size-1] byte_comp;

generate
	for (i=0; i<comp_size; i=i+1)
	begin:
		bit_comp bit_comp[i] (
				.bit_a(byte_a[i]),
				.bit_b(byte_b[i]),
				.bit_comp(byte_comp[i]),
				.start(start),
				.done(done)
		);
endgenerate
