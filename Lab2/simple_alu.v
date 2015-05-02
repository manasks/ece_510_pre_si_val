`timescale 1ns/1ps
`include "alu.pkg"
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

logic overflow;

wire overflow_buf;

logic done;
logic [DATA_WIDTH-1:0] result;

parameter ON = 1'b1;
parameter OFF = 1'b0;

parameter

    RESET   = 4'b0000,
    IDLE    = 4'b0001,
    DATA_A  = 4'b0010,
    DATA_B  = 4'b0011,
    S_ADD   = 4'b0100,
    S_SUB   = 4'b0101,
    S_PAR   = 4'b0110,
    S_COMP  = 4'b0111,
    DONE    = 4'b1000;

logic [3:0] State, NextState;
logic [DATA_WIDTH-1:0] A_Data, B_Data;
logic [1:0] opcode_def;
logic store_a_def, store_b_def;
wire [DATA_WIDTH-1:0] result_def;
logic [1:0] opcode_buf;
logic store_a, store_b;
logic start;
wire alu_done;

logic first;

always_ff @(posedge clk or reset_n)
begin
    if(!reset_n)
	begin
        State = RESET;
	end
    else
	begin
        State = NextState;
	end
end

always_comb
begin
    case(State)
        RESET:
        begin
			if(reset_n)
			begin
				NextState = IDLE;
            end
			else
			begin
				NextState = RESET;
			end
        end

        IDLE:
        begin
			if(opcode_valid)
			begin
                NextState = DATA_A;
			end
			else
            begin    
				NextState = IDLE;
		    end
        end

        DATA_A:
        begin
			if(opcode_valid)
			begin
				NextState = DATA_B;
                opcode_buf[0] = opcode;
			end
			else
			begin
				NextState = IDLE;
			end
        end

        DATA_B:
        begin
		    opcode_buf[1] = opcode;
            if(opcode_valid)
			begin
				case(opcode_buf)
					ADD:
					begin
						NextState = ADD;
					end
					
					SUB:
					begin
						NextState = SUB;
					end
					
					PAR:
					begin
						NextState = PAR;
					end
					
					COMP:
					begin
						NextState = COMP;
					end				
				endcase
			end
			else
			begin
				NextState = IDLE;
			end
        end

        S_ADD:
        begin
			if(alu_done)
			begin
				NextState = DONE;
			end
			else
			begin
				NextState = ADD;
			end
        end

        S_SUB:
        begin
			if(alu_done)
			begin
				NextState = DONE;
			end
			else
			begin
				NextState = SUB;
			end
        end

        S_PAR:
        begin
			if(alu_done)
			begin
				NextState = DONE;
			end
			else
			begin
				NextState = PAR;
			end
        end

        S_COMP:
        begin
			if(alu_done)
			begin
				NextState = DONE;
			end
			else
			begin
				NextState = COMP;
			end
        end

        DONE:
        begin
			NextState = IDLE;
        end
	endcase
end

always_comb
begin
    case(State)
        RESET:
        begin
            store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = ADD;
			start = OFF;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        IDLE:
        begin
			store_a_def = OFF;
            store_b_def = OFF;
			opcode_def = ADD;
			start = OFF;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        DATA_A:
        begin
            store_a_def = ON;
			store_b_def = OFF;
            start = OFF;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        DATA_B:
        begin
			store_a_def = OFF;
			store_b_def = ON;
            start = OFF;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        S_ADD:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = ADD;
			start = 1'b1;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        S_SUB:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = SUB;
			start = ON;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        S_PAR:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = PAR;
			start = ON;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        S_COMP:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = COMP;
			start = ON;
			result = 0;
			done = OFF;
            overflow = OFF;
        end

        DONE:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = 2'b00;
			start = OFF;
			result = result_def;
			done = ON;
            overflow = overflow_buf;
        end
	endcase
end

	alu_datapath alu_datapath (
			.clk(clk),
			.alu_data(data),
			.opcode_value(opcode_def),
			.store_a(store_a_def),
			.store_b(store_b_def),
			.start(start),
			.alu_done(alu_done),
			.result(result_def),
			.overflow_def(overflow_buf)
	);

endmodule

