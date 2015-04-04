module byte_adder(byte_a, byte_b, byte_carry_in, byte_sum, byte_overflow, start, done)

input [DATA_WIDTH-1:0] byte_a;
input [DATA_WIDTH-1:0] byte_b;
input byte_carry_in;

output [DATA_WIDTH-1:0] byte_sum;
output byte_overflow;

wire [DATA_WIDTH:0] carry_buf;

reg [DATA_WIDTH-1:0] byte_a_buf;
reg [DATA_WIDTH-1:0] byte_b_buf;

assign carry_buf[0] = byte_carry_in;
assign byte_a_buf = byte_a;
assign byte_b_buf = byte_b;
assign byte_overflow = carry_buf[DATA_WIDTH];

generate
	for (i=0; i<DATA_WIDTH; i=i+1)
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