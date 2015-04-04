module byte_adder(byte_a, byte_b, byte_carry_in, byte_sum, byte_overflow, start, done)

parameter adder_size = 8;

input [adder_size-1:0] byte_a;
input [adder_size-1:0] byte_b;
input byte_carry_in;

output [adder_size-1:0] byte_sum;
output byte_overflow;

wire [adder_size:0] carry_buf;

reg [adder_size-1:0] byte_a_buf;
reg [adder_size-1:0] byte_b_buf;

assign carry_buf[0] = byte_carry_in;
assign byte_a_buf = byte_a;
assign byte_b_buf = byte_b;
assign byte_overflow = carry_buf[adder_size];

generate
	for (i=0; i<adder_size; i=i+1)
	begin:
		bit_adder bit_add[i] (
				.bit_a(byte_a_buf[i]),
				.bit_b(byte_b_buf[i]),
				.bit_carry_in(carry_buf[i]),
				.bit_sum(byte_sum[i]),
				.bit_carry_out(carry_buf[i+1]),
				.start(start),
				.done(done)
		);
endgenerate