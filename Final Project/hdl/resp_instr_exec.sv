`include "pdp8_pkg.sv"
module resp_instr_exec
(
	input clk,
	input [`ADDR_WIDTH-1:0] exec_wr_addr,
	input [`DATA_WIDTH-1:0] exec_wr_data,
	input exec_wr_req,
	input [`ADDR_WIDTH-1:0] exec_rd_addr,
	input exec_rd_req,
	output [`DATA_WIDTH-1:0] exec_rd_data
);

logic [`DATA_WIDTH-1:0] mem_array[4095:0];

assign exec_rd_data = mem_array[exec_rd_addr];

initial
begin
        foreach(mem_array[i])
        begin
              mem_array[i] = i;
        end
end

always_ff @(posedge clk)
begin
	if(exec_wr_req)
	begin
		mem_array[exec_wr_addr] = exec_wr_data;
	end
end

endmodule
