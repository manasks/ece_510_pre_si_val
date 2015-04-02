module byte_adder(byte_a, byte_b, byte_carry_in, byte_sum, byte_overflow)

input [7:0] byte_a;
input [7:0] byte_b;
input byte_carry_in;

output [7:0] byte_sum;
output byte_overflow;

wire [7:0] carry_buf;

	bit_adder bit0(
				.bit_a(byte_a[0]),
				.bit_b(byte_b[0]),
				.bit_carry_in(byte_carry_in),
				.bit_diff(byte_sum[0]),
				.bit_carry_out(carry_buf[0])
	);
	
	bit_adder bit1(
				.bit_a(byte_a[1]),
				.bit_b(byte_b[1]),
				.bit_carry_in(carry_buf[0]),
				.bit_diff(byte_sum[1]),
				.bit_carry_out(carry_buf[1])
	);
	
	bit_adder bit2(
				.bit_a(byte_a[2]),
				.bit_b(byte_b[2]),
				.bit_carry_in(carry_buf[1]),
				.bit_diff(byte_sum[2]),
				.bit_carry_out(carry_buf[2])
	);
	
	bit_adder bit3(
				.bit_a(byte_a[3]),
				.bit_b(byte_b[3]),
				.bit_carry_in(carry_buf[2]),
				.bit_diff(byte_sum[3]),
				.bit_carry_out(carry_buf[3])
	);
	
	bit_adder bit4(
				.bit_a(byte_a[4]),
				.bit_b(byte_b[4]),
				.bit_carry_in(carry_buf[3]),
				.bit_diff(byte_sum[4]),
				.bit_carry_out(carry_buf[4])
	);
	
	bit_adder bit5(
				.bit_a(byte_a[5]),
				.bit_b(byte_b[5]),
				.bit_carry_in(carry_buf[4]),
				.bit_diff(byte_sum[5]),
				.bit_carry_out(carry_buf[5])
	);
	
	bit_adder bit6(
				.bit_a(byte_a[6]),
				.bit_b(byte_b[6]),
				.bit_carry_in(carry_buf[5]),
				.bit_diff(byte_sum[6]),
				.bit_carry_out(carry_buf[6])
	);
	
	bit_adder bit7(
				.bit_a(byte_a[7]),
				.bit_b(byte_b[7]),
				.bit_carry_in(carry_buf[6]),
				.bit_diff(byte_sum[7]),
				.bit_carry_out(carry_buf[7])
	);
	