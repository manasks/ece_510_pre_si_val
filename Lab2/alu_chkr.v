`timescale 1ns/1ps
`include "alu.pkg"
module alu_chkr(clk, reset_n, opcode_valid, opcode, data, result, overflow, done, checker_enable);

input clk;
input reset_n;
input opcode_valid;
input opcode;
input [DATA_WIDTH-1:0] data;
input [DATA_WIDTH-1:0] result;
input overflow;
input done;
input [4:0] checker_enable;

reg [DATA_WIDTH:0] result_buf;

reg [DATA_WIDTH-1:0] data_A;
reg [DATA_WIDTH-1:0] data_B;

reg [1:0] opcode_buf;

reg chkr1_State;
reg [1:0] chkr3_State;
reg [1:0] chkr4_State;
reg [1:0] chkr5_State;

parameter chkr1_CHECK = 1'b1;
parameter chkr1_RESET = 1'b0;

parameter chkr3_OPCODE1 = 2'b00;
parameter chkr3_OPCODE2 = 2'b01;
parameter chkr3_COMPUTE = 2'b10;
parameter chkr3_CHECK = 2'b11;

parameter chkr4_OPCODE1 = 2'b00;
parameter chkr4_OPCODE2 = 2'b01;
parameter chkr4_DONE = 2'b10;

parameter chkr5_OPCODE1 = 2'b00;
parameter chkr5_OPCODE2 = 2'b01;
parameter chkr5_DONE = 2'b10;

initial
begin
    chkr1_State = chkr1_RESET;
    chkr3_State = chkr3_OPCODE1;
    chkr4_State = chkr4_OPCODE1;
    chkr5_State = chkr5_OPCODE1;
end

always @(posedge clk)
begin
    //$display("opcode: %h \t opcode_valid: %h \t data: %h \t result: %h \t overflow: %h \t done: %h",opcode, opcode_valid, data, result, overflow, done);
end

//Checker 1: when reset_n is asserted (driven to 0), all outputs become 0
//within 1 clock cycle.
always @(posedge clk)
begin
    case(chkr1_State)
		chkr1_RESET:
		begin
			if(reset_n && checker_enable[0])
			begin
				chkr1_State = chkr1_CHECK;
			end
			else
			begin
				chkr1_State = chkr1_RESET;
			end
		end
		
		chkr1_CHECK:
		begin
			if (!data && !overflow && !done)
			begin
				$display("CHECKER 1 FAILED");
			end
			else
			begin
				$display("CHECKER 1 PASSED");
			end
			chkr1_State = chkr1_RESET;
		end
	endcase
end

//Checker 2: when opcode_valid is asserted, valid opcode and valid data
//(no X or Z) must be driven on the same cycle.
always @(posedge clk)
begin
    if (opcode_valid && checker_enable[1])
    begin
       if(opcode == "x" || data == "xxxxxxxx")
       begin
            $display("CHECKER 2 FAILED");
       end
       else if(opcode == "z" || data == "zzzzzzzz")
       begin
            $display("CHECKER 2 FAILED");
       end
       else
       begin
            $display("CHECKER 2 PASSED");
       end
    end
end

//Checker 3: Output “done” must be asserted within 2 cycles after both valid data 
//have been captured.
always @(posedge clk)
begin
    case(chkr3_State)
        chkr3_OPCODE1:
		begin
			if (opcode_valid && checker_enable[2])
			begin
				chkr3_State = chkr3_OPCODE2;
			end
			else
			begin
				chkr3_State = chkr3_OPCODE1;
			end
		end
		
		chkr3_OPCODE2:
		begin
			if (opcode_valid)
			begin
				chkr3_State = chkr3_COMPUTE;
			end
			else
			begin
				chkr3_State = chkr3_OPCODE2;
			end
		end
		
		chkr3_COMPUTE:
		begin
			chkr3_State = chkr3_CHECK;
		end
		
		chkr3_CHECK:
		begin
			if (done)
			begin
				$display("CHECKER 3 PASSED");
				chkr3_State = chkr3_OPCODE1;
			end
			else
			begin
				$display("CHECKER 3 FAILED");
                chkr3_State = chkr3_OPCODE1;
			end
		end
	endcase	
end

//Checker 4: Once “done’ is asserted, output “result” must be correct
//on the same cycle.
always @(posedge clk or done or opcode_valid or result or data or overflow or checker_enable[3])
begin
	case(chkr4_State)
		chkr4_OPCODE1:
		begin
			if(opcode_valid && checker_enable[3])
			begin
				data_A = data;
				opcode_buf[0] = opcode;
				chkr4_State = chkr4_OPCODE2;
			end
			else
			begin
				chkr4_State = chkr4_OPCODE1;
			end
		end
		
		chkr4_OPCODE2:
		begin
			if(opcode_valid)
			begin
				data_B = data;
				opcode_buf[1] = opcode;
				chkr4_State = chkr4_DONE;
			end
			else
			begin
				chkr4_State = chkr4_OPCODE2;
			end
		end
		
		chkr4_DONE:
		begin
			if(done)
			begin
				case(opcode_buf)
					2'b00:
					begin
						result_buf = data_A + data_B;
					end
					
					2'b01:
					begin
						result_buf = data_A - data_B;
					end
					
					2'b10:
					begin
						result_buf = data_A ^ data_B;
					end
					
					2'b11:
					begin
						result_buf = data_A ~^ data_B;
					end
				endcase
				if (result == result_buf[DATA_WIDTH-1:0])
				begin
					$display("CHECKER 4 PASSED");
				end
				else
				begin
					$display("CHECKER 4 FAILED");
				end
				chkr4_State = chkr4_OPCODE1;
			end
			else
			begin
				chkr4_State = chkr4_OPCODE1;
			end
		end
	endcase
end

//Checker 5: Once “done’ is asserted, output “overflow” must be correct on the 
//same cycle.
always @(posedge clk or done or overflow or checker_enable[4])
begin
	case(chkr5_State)
		chkr5_OPCODE1:
		begin
			if(opcode_valid && checker_enable[3])
			begin
				data_A = data;
				opcode_buf[0] = opcode;
				chkr5_State = chkr5_OPCODE2;
			end
			else
			begin
				chkr5_State = chkr5_OPCODE1;
			end
		end
		
		chkr5_OPCODE2:
		begin
			if(opcode_valid)
			begin
				data_B = data;
				opcode_buf[1] = opcode;
				chkr5_State = chkr5_DONE;
			end
			else
			begin
				chkr5_State = chkr5_OPCODE2;
			end
		end
		
		chkr5_DONE:
		begin
			if(done)
			begin
				case(opcode_buf)
					2'b00:
					begin
						result_buf = data_A + data_B;
					end
					
					2'b01:
					begin
						result_buf = data_A - data_B;
					end
					
					2'b10:
					begin
						result_buf = data_A ^ data_B;
					end
					
					2'b11:
					begin
						result_buf = data_A ~^ data_B;
					end
				endcase
				if (overflow == result_buf[DATA_WIDTH])
				begin
					$display("CHECKER 5 PASSED");
				end
				else
				begin
					$display("CHECKER 5 FAILED");
				end
				chkr5_State = chkr5_OPCODE1;
			end
			else
			begin
				chkr5_State = chkr5_OPCODE1;
			end
		end
	endcase
end

endmodule
