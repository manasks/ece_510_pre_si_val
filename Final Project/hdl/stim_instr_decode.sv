`include "pdp8_pkg.sv"
import pdp8_pkg::*;
module stim_instr_decode
(
	// Global inputs and outputs
	input clk,
	output reg stall,
	output reg [`ADDR_WIDTH-1:0]PC_value,
	
	// From the execution unit
	input ifu_rd_req,
	input [`ADDR_WIDTH-1:0] ifu_rd_addr,
	
	//To the execution unit
	
	output reg [`DATA_WIDTH-1:0] ifu_rd_data
	
);
logic [`DATA_WIDTH-1:0] mem_array[(2**`ADDR_WIDTH-1):0];
reg [11:0] testcase;

initial
begin
stall = 1'b0;
PC_value = 12'o200;
end 

always @(posedge clk) begin
	if (ifu_rd_req == 1) begin
		PC_value = PC_value + 1;
		end
end
		
always @(posedge clk) 
begin	
	if(ifu_rd_req)
	begin	
		testcase[11:9] = $urandom_range(0,7);
		testcase[6:0] = $urandom_range(0,128);
		testcase[8:7] = $urandom_range(0,3);
		mem_array[ifu_rd_addr] = testcase ;
		ifu_rd_data = mem_array[ifu_rd_addr];
	end
end


/*always @ (*
begin
$display(" addr: %d  req: %d   data: %h   data de %d", ifu_rd_addr,ifu_rd_req, ifu_rd_data,ifu_rd_data);
end*/
////comment everything



endmodule