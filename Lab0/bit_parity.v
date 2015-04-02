module bit_parity(bit_a, bit_b, bit_parity_out)

input bit_a;
input bit_b;

output bit_parity_out;

assign bit_parity_out <= bit_a xor bit_b;