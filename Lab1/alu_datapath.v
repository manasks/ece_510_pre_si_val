module alu_datapath(clk, alu_data, opcode_value, store_a, store_b, start, alu_done, result, overflow_def);

parameter DATA_WIDTH = 8;

input clk;
input alu_data;
input opcode_value;
input store_a;
input store_b;
input start;

output alu_done;
output result;
output overflow_def;

reg overflow_def;

wire clk;
wire [DATA_WIDTH-1:0] alu_data;
wire [1:0] opcode_value;
wire store_a;
wire store_b;
wire start;

reg alu_done;
reg start_def;
reg [DATA_WIDTH-1:0] result;

parameter ON 		= 1'b1;
parameter OFF 		= 1'b0;
parameter ADD 		= 2'b00;
parameter SUB 		= 2'b01;
parameter PAR 		= 2'b10;
parameter COMP 		= 2'b11;

reg [DATA_WIDTH-1:0] buf_a;
reg [DATA_WIDTH-1:0] buf_b;
wire done;

reg [DATA_WIDTH-1:0] add_a;
reg [DATA_WIDTH-1:0] add_b;
wire [DATA_WIDTH-1:0] add_sum;
reg add_carry_in;
wire add_overflow;

reg [DATA_WIDTH-1:0] sub_a;
reg [DATA_WIDTH-1:0] sub_b;
wire [DATA_WIDTH-1:0] sub_diff;
reg sub_borrow_in;
wire sub_borrow_out;

reg [DATA_WIDTH-1:0] par_a;
reg [DATA_WIDTH-1:0] par_b;
wire [DATA_WIDTH-1:0] par_parity;

reg [DATA_WIDTH-1:0] comp_a;
reg [DATA_WIDTH-1:0] comp_b;
wire [DATA_WIDTH-1:0] comp_comp;

always @(posedge clk or store_a or store_b or start)
begin
    if(store_a)
    begin
		buf_a = alu_data;
    end
	else if(store_b)
    begin    
		buf_b = alu_data;
	end
	else if(start)
	begin
        case(opcode_value)
			ADD:
			begin
				add_a = buf_a;
				add_b = buf_b;
				add_carry_in = 1'b0;
                start_def = 1'b1;
			end
			
			SUB:
			begin
				sub_a = buf_a;
				sub_b = buf_b;
				sub_borrow_in = 1'b0;
                start_def = 1'b1;
			end
		
			PAR:
			begin
				par_a = buf_a;
				par_b = buf_b;
                start_def = 1'b1;
			end
			
			COMP:
			begin
				comp_a = buf_a;
				comp_b = buf_b;
                start_def = 1'b1;
			end
		endcase
	end
end

always @(posedge clk or done)
begin
    if(done)
	begin
        case(opcode_value)
			ADD:
			begin
				result 	= add_sum;
				overflow_def = add_overflow;
				alu_done = ON;
			end
			
			SUB:
			begin
                result = sub_diff;
				overflow_def = sub_borrow_out;
				alu_done = ON;
			end
		
			PAR:
			begin
                result = par_parity;
                alu_done = ON;
                overflow_def = OFF;
			end
			
			COMP:
			begin
				result = comp_a ^~ comp_b;
                alu_done = ON;
                overflow_def = OFF;
			end
		endcase
	end
	else
	begin
		result = 0;
		overflow_def = 0;
		alu_done = OFF;
	end
end

	byte_adder #(DATA_WIDTH) adder_ex(
			.byte_a(add_a),
			.byte_b(add_b),
			.byte_carry_in(add_carry_in),
			.byte_sum(add_sum),
			.byte_overflow(add_overflow),
			.start(start_def),
			.done(done)
	);

	byte_subtractor #(DATA_WIDTH) subtractor_ex(
			.byte_a(sub_a),
			.byte_b(sub_b),
			.byte_borrow_in(sub_borrow_in),
			.byte_diff(sub_diff),
			.byte_borrow_out(sub_borrow_out),
			.start(start_def),
			.done(done)
	);
	
	byte_parity #(DATA_WIDTH) parity_ex(
			.byte_a(par_a),
			.byte_b(par_b),
			.byte_parity(par_parity),
			.start(start_def),
			.done(done)
	);

	byte_comp #(DATA_WIDTH) comp_ex(
			.byte_a(comp_a),
			.byte_b(comp_b),
			.byte_comp(comp_comp),
			.start(start_def),
			.done(done)
	);

endmodule

