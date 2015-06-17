`include "pdp8_pkg.sv"
module resp_instr_decode
(
	//From the DUT
   input                    ifu_rd_req,
   input  [`ADDR_WIDTH-1:0] ifu_rd_addr,
   
   //To the DUT
   output [`DATA_WIDTH-1:0] ifu_rd_data
);

logic [`DATA_WIDTH-1:0] mem_array[(2**`ADDR_WIDTH-1):0];



always_comb 
begin	
	if(ifu_rd_req)
	begin	
		ifu_rd_data = mem_array(ifu_rd_addr);
	end
end

endmodule

//create detersministic values
//create meaningful random class values