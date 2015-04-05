module byte_adder(

    input [DATA_WIDTH-1:0] byte_a,
    input [DATA_WIDTH-1:0] byte_b,
    input byte_carry_in,
    input start,

    output [DATA_WIDTH-1:0] byte_sum,
    output byte_overflow,
    output done
);

reg [DATA_WIDTH-1:0] byte_sum;
reg byte_overflow;
reg done;

reg [DATA_WIDTH:0] carry_buf;

reg [DATA_WIDTH-1:0] byte_a_buf;
reg [DATA_WIDTH-1:0] byte_b_buf;

assign carry_buf[0] = byte_carry_in;
assign byte_a_buf = byte_a;
assign byte_b_buf = byte_b;
assign byte_overflow = carry_buf[DATA_WIDTH];

genvar i;

    generate
	    for (i=0; i<DATA_WIDTH; i=i+1)
	    begin:
		    bit_adder bit_add (
			    	.bit_a(byte_a_buf[i]),
				    .bit_b(byte_b_buf[i]),
				    .bit_carry_in(carry_buf[i]),
				    .bit_sum(byte_sum[i]),
			    	.bit_carry_out(carry_buf[i+1]),
			    	.start(start),
			    	.done(done)
		    );
        end
    endgenerate

endmodule
