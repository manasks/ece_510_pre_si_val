module bit_subtractor(bit_a, bit_b, bit_borrow_in, bit_diff, bit_borrow_out, start, done)

input bit_a;
input bit_b;
input bit_borrow_in;
input start;

output bit_diff;
output bit_borrow_out;
output done;

assign bit_diff = (bit_a ^ bit_b) ^ bit_borrow_in;
<<<<<<< HEAD
assign bit_borrow_out = ((~bite_a & bit_borrow_in) | (~bit_a & bit_b) | (bit_b & bit_borrow_in));
assign done = start;
=======
assign bit_borrow_out = ((~bit_a & bit_borrow_in) | (~bit_a & bit_b) | (bit_b & bit_borrow_in));
assign done = start;
>>>>>>> parent of 7e75e3e... commit
