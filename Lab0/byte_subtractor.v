module byte_subtractor(byte_a, byte_b, byte_borrow_in, byte_diff, byte_borrow_out)

input byte_a;
input byte_b;
input byte_borrow_in;

output byte_diff;
output byte_borrow_out;

wire [7:0] borrow_buf;

	bit_subtractor bit0(
				.bit_a(byte_a[0]),
				.bit_b(byte_b[0]),
				.bit_borrow_in(byte_borrow_in),
				.bit_diff(byte_diff[0]),
				.bit_borrow_out(borrow_buf[0])
	);
	
	bit_subtractor bit1(
				.bit_a(byte_a[1]),
				.bit_b(byte_b[1]),
				.bit_borrow_in(borrow_buf[0]),
				.bit_diff(byte_diff[1]),
				.bit_borrow_out(borrow_buf[1])
	);
	
	bit_subtractor bit2(
				.bit_a(byte_a[2]),
				.bit_b(byte_b[2]),
				.bit_borrow_in(borrow_buf[1]),
				.bit_diff(byte_diff[2]),
				.bit_borrow_out(borrow_buf[2])
	);
	
	bit_subtractor bit3(
				.bit_a(byte_a[3]),
				.bit_b(byte_b[3]),
				.bit_borrow_in(borrow_buf[2]),
				.bit_diff(byte_diff[3]),
				.bit_borrow_out(borrow_buf[3])
	);
	
	bit_subtractor bit4(
				.bit_a(byte_a[4]),
				.bit_b(byte_b[4]),
				.bit_borrow_in(borrow_buf[3]),
				.bit_diff(byte_diff[4]),
				.bit_borrow_out(borrow_buf[4])
	);
	
	bit_subtractor bit5(
				.bit_a(byte_a[5]),
				.bit_b(byte_b[5]),
				.bit_borrow_in(borrow_buf[4]),
				.bit_diff(byte_diff[5]),
				.bit_borrow_out(borrow_buf[5])
	);
	
	bit_subtractor bit6(
				.bit_a(byte_a[6]),
				.bit_b(byte_b[6]),
				.bit_borrow_in(borrow_buf[5]),
				.bit_diff(byte_diff[6]),
				.bit_borrow_out(borrow_buf[6])
	);
	
	bit_subtractor bit7(
				.bit_a(byte_a[7]),
				.bit_b(byte_b[7]),
				.bit_borrow_in(borrow_buf[6]),
				.bit_diff(byte_diff[7]),
				.bit_borrow_out(byte_borrow_out)
	);
