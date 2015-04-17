module alu_chkr(clk, reset_n, opcode_valid, data, result, overflow, done, checker_enable);

parameter DATA_WIDTH = 8;

input clk;
input reset_n;
input opcode_valid;
input [DATA_WIDTH-1:0] data;
input result;
input overflow;
input done;
input [4:0] checker_enable;

//Checker 1: when reset_n is asserted (driven to 0), all outputs become 0
//within 1 clock cycle.
always @(posedge clk or reset_n or checker_enable[0])
begin
	
end

//Checker 2: when opcode_valid is asserted, valid opcode and valid data
//(no X or Z) must be driven on the same cycle.
always @(posedge clk or opcode_valid or checker_enable[1])
begin

end

//Checker 3: Output “done” must be asserted within 2 cycles after both valid data 
//have been captured.
always @(posedge clk or opcode_valid or done or checker_enable[2])
begin

end

//Checker 4: Once “done’ is asserted, output “result” must be correct
//on the same cycle.
always @(posedge clk or done or result or data or overflow or checker_enable[3])
begin

end

//Checker 5: Once “done’ is asserted, output “overflow” must be correct on the 
//same cycle.
always @(posedge clk or done or overflow or checker_enable[4])
begin

end
