module simple_alu(clk, reset_n, opcode_valid, opcode, data, done, result, overflow);

input clk;
input reset_n;
input opcode_valid;
input opcode;
input [DATA_WIDTH-1:0] data;

output done;
output [DATA_WIDTH-1:0] result;
output overflow;

parameter ON = 1'b1;
parameter OFF = 1'b0;

parameter

    RESET   = 4'b0000,
    IDLE    = 4'b0001,
    DATA_A  = 4'b0010,
    DATA_B  = 4'b0011,
    ADD     = 4'b0100,
    SUB     = 4'b0101,
    PAR     = 4'b0110,
    COMP    = 4'b0111,
    DONE    = 4'b1000;

parameter
    ADD     = 2'b00,
    SUB     = 2'b01,
    PAR     = 2'b10,
    COMP    = 2'b11;

reg [DATA_WIDTH-1:0]result;
reg overflow;
reg done;
reg [3:0] State, NextState;
reg [DATA_WIDTH-1:0] A_Data, B_Data;
reg [1:0] opcode_def;
reg [1:0] opcode_buf;
reg store_a, store_b;
reg start, alu_done;

assign done = alu_done;

always @(posedge clk,reset_n)
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


always @(State,opcode_valid,opcode,reset_n)
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
				opcode_buf[0] = opcode;
			end
			else
				NextState = IDLE;
			begin
			end
        end

        DATA_A:
        begin
			if(opcode_valid)
			begin
				NextState = DATA_B;
				opcode_buf[1] = opcode;
			end
			else
			begin
				NextState = IDLE;
			end
        end

        DATA_B:
        begin
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
					
					COMP
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

        ADD:
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

        SUB:
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

        PAR:
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

        COMP:
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

always @(State)
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
        end

        IDLE:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = ADD;
			start = OFF;
			result = 0;
			done = OFF;
        end

        DATA_A:
        begin
			store_a_def = ON;
			store_b_def = OFF;
			opcode_def = opcode_buf;
			start = OFF;
			result = 0;
			done = OFF;
        end

        DATA_B:
        begin
			store_a_def = OFF;
			store_b_def = ON;
			opcode_def = opcode_buf;
			start = OFF;
			result = 0;
			done = OFF;
        end

        ADD:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = ADD;
			start = ON;
			result = 0;
			done = OFF;
        end

        SUB:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = SUB;
			start = ON;
			result = 0;
			done = OFF;
        end

        PAR:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = PAR;
			start = ON;
			result = 0;
			done = OFF;
        end

        COMP:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = COMP;
			start = ON;
			result = 0;
			done = OFF;
        end

        DONE:
        begin
			store_a_def = OFF;
			store_b_def = OFF;
			opcode_def = 2'b00;
			start = OFF;
			result = result_def;
			done = ON;
        end
	endcase
end

	alu_datapath (
			.clk(clk),
			.alu_data(data),
			.opcode_value(opcode_def),
			.store_a(store_a_def),
			.store_b(store_b_def),
			.start(start),
			.alu_done(alu_done),
			.result(result_def),
			.overflow(overflow_def)
	);