module bit_subtractor(bit_a, bit_b, bit_carry_in, bit_diff, bit_carry_out)

input bit_a;
input bit_b;
input bit_carry_in;

output bit_sum;
output bit_carry_out;

assign bit_sum <= bit_a xnor bit_b xnor bit_carry_in;
assign bit_carry_out <= ;