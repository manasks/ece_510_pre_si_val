module simple_alu(clk, reset_n, opcode_valid, opcode, data, done, result, overflow);

parameter DATA_WIDTH = 8;

input clk;
input reset_n;
input opcode_valid;
input opcode;
input [DATA_WIDTH-1:0] data;

output done;
output [DATA_WIDTH-1:0] result;
output overflow;

reg overflow;

wire overflow_buf;

reg done;
reg [DATA_WIDTH-1:0] result;

always @(posedge clk)
begin
    $display("\n opcode_valid: %h \t opcode: %h \t data: %h \t reset_n: %h", opcode_valid, opcode, data, reset_n);
    done = 1'b1;
end






endmodule

