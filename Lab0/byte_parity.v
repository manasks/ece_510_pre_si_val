module byte_parity(byte_a, byte_b, byte_parity, start, done)

parameter parity_size = 8;

input [parity_size-1] byte_a;
input [parity_size-1] byte_b;
input byte_borrow_in;

output [parity_size-1] byte_parity;

generate
	for (i=0; i<parity_size; i=i+1)
	begin:
		bit_parity bit_par[i] (
				.bit_a(byte_a[i]),
				.bit_b(byte_b[i]),
				.bit_parity(byte_parity[i]),
				.start(start),
				.done(done)
		);
endgenerate
