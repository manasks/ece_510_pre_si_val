module byte_subtractor(byte_a, byte_b, byte_borrow_in, byte_diff, byte_borrow_out, start, done)

input [DATA_WIDTH-1] byte_a;
input [DATA_WIDTH-1] byte_b;
input byte_borrow_in;

output [DATA_WIDTH-1] byte_diff;
output byte_borrow_out;

wire [DATA_WIDTH:0] borrow_buf;

reg [DATA_WIDTH-1:0] byte_a_buf;
reg [DATA_WIDTH-1:0] byte_b_buf;

assign borrow_buf[0] = byte_borrow_in;
assign byte_a_buf = byte_a;
assign byte_b_buf = byte_b;
assign byte_borrow_out = borrow_buf[DATA_WIDTH];


generate
	for (i=0; i<DATA_WIDTH; i=i+1)
	begin:
		bit_subtractor bit_sub[i] (
				.bit_a(byte_a[i]),
				.bit_b(byte_b[i]),
				.bit_borrow_in(borrow_buf[i]),
				.bit_diff(byte_diff[i]),
				.bit_borrow_out(borrow_buf[i+1]),
				.start(start),
				.done(done)
		);
endgenerate
