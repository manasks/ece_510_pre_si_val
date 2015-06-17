//Checker module
//This module is a checker module. It inputs all the outputs of DUT and the Stimulus/Responder

`include "pdp8_pkg.sv"
import pdp8_pkg::*;
module chkr_instr_decode
(
	//From the stimulus
	input clk,
	input reset_n,
	input stall,
	
	//From the Stimulus
    input [`ADDR_WIDTH-1:0] PC_value,
	
	//From the DUT to the stimulus
    input                   ifu_rd_req,
    input [`ADDR_WIDTH-1:0] ifu_rd_addr,
	
	//From the stimulus
    input [`DATA_WIDTH-1:0] ifu_rd_data,
    input [`ADDR_WIDTH-1:0] base_addr,
	
	//From the DUT
    input pdp_mem_opcode_s pdp_mem_opcode,
    input pdp_op7_opcode_s pdp_op7_opcode
);

reg [`DATA_WIDTH-1:0] int_read_data;
pdp_mem_opcode_s pdp_mem_opcode_a;
pdp_op7_opcode_s pdp_op7_opcode_a;

enum {IDLE,
         READY,
         SEND_REQ,
         DATA_RCVD,
         INST_DEC,
         STALL,
         DONE } current_state, next_state;


always @ ( posedge  clk) begin 
		@(negedge ifu_rd_req) begin
		#10 int_read_data = ifu_rd_data;
		checker_task(int_read_data,pdp_mem_opcode_a,pdp_op7_opcode_a);
		end
end


//The checker is here
//Task to decode the received instructions
task checker_task(input [`DATA_WIDTH-1:0] int_read_data, output pdp_mem_opcode_s pdp_mem_opcode_a, output pdp_op7_opcode_s pdp_op7_opcode_a );
pdp_mem_opcode_a = '{0,0,0,0,0,0,9'bz};
pdp_op7_opcode_a = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

//Group1
if(int_read_data[11:9]<3'd6) begin
	case(int_read_data[11:9]) 
	3'd0:pdp_mem_opcode_a.AND=1;  
	3'd1:pdp_mem_opcode_a.TAD=1;
	3'd2:pdp_mem_opcode_a.ISZ=1;
	3'd3:pdp_mem_opcode_a.DCA=1;
	3'd4:pdp_mem_opcode_a.JMS=1;
	3'd5:pdp_mem_opcode_a.JMP=1;
	endcase
end

//Micro op instructions decode
if(int_read_data[11:9] == 3'b111) begin
	case(int_read_data)
	12'o7000:pdp_op7_opcode_a.NOP = 1;
	12'o7001:pdp_op7_opcode_a.IAC = 1;
	12'o7004:pdp_op7_opcode_a.RAL = 1;
	12'o7006:pdp_op7_opcode_a.RTL = 1;
	12'o7010:pdp_op7_opcode_a.RAR = 1;
	12'o7012:pdp_op7_opcode_a.RTR = 1;
	12'o7020:pdp_op7_opcode_a.CML = 1;
	12'o7040:pdp_op7_opcode_a.CMA = 1;
	12'o7041:pdp_op7_opcode_a.CIA = 1;
	12'o7104:pdp_op7_opcode_a.CLL = 1;
	12'o7200:pdp_op7_opcode_a.CLA1 = 1;
	12'o7300:pdp_op7_opcode_a.CLA_CLL = 1;
	12'o7402:pdp_op7_opcode_a.HLT = 1;
	12'o7404:pdp_op7_opcode_a.OSR = 1;
	12'o7410:pdp_op7_opcode_a.SKP = 1;
	12'o7420:pdp_op7_opcode_a.SNL = 1;
	12'o7430:pdp_op7_opcode_a.SZL = 1;
	12'o7440:pdp_op7_opcode_a.SZA = 1;
	12'o7450:pdp_op7_opcode_a.SNA = 1;
	12'o7500:pdp_op7_opcode_a.SMA = 1;
	12'o7510:pdp_op7_opcode_a.SPA = 1;
	12'o7600:pdp_op7_opcode_a.CLA2 = 1;
	default:pdp_op7_opcode_a.NOP = 1;
	endcase
end
endtask



//Assertions property declaration 
//Group 1
property AND_state;
	##1 ifu_rd_req |-> ##[1:2] pdp_mem_opcode.AND;	
endproperty

property TAD_state;
##1 ifu_rd_req |-> ##[1:2] pdp_mem_opcode.TAD;	
endproperty

property ISZ_state;
##1 ifu_rd_req |-> ##[1:2] pdp_mem_opcode.ISZ;
endproperty

property DCA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_mem_opcode.DCA;
endproperty

property JMP_state;
##1 ifu_rd_req |-> ##[1:2] pdp_mem_opcode.JMP;
endproperty
 
property JMS_state;
##1 ifu_rd_req |-> ##[1:2] pdp_mem_opcode.JMS;
endproperty 

//Micro op 

property NOP_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.NOP;
endproperty

property IAC_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.IAC;
endproperty

property RAL_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.RAL;
endproperty

property RTL_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.RTL;
endproperty

property RAR_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.RAR;
endproperty

property RTR_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.RTR;
endproperty

property CML_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CML
endproperty

property CMA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CMA;
endproperty

property CIA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CIA;
endproperty

property CLL_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CLL;
endproperty

property CLA1_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CLA1;
endproperty

property CLA_CLL_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CLA_CLL;
endproperty

property HLT_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.HLT;
endproperty

property OSR_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.OSR;
endproperty

property SKP_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SKP;
endproperty

property SNL_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SNL;
endproperty

property SZL_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SZL;
endproperty

property SZA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SZA;
endproperty

property SNA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SNA;
endproperty

property SMA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SMA;
endproperty

property SPA_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.SPA;
endproperty

property CLA2_state;
##1 ifu_rd_req |-> ##[1:2] pdp_op7_opcode.CLA2;
endproperty


//Calling all assertions based on the first bit of the octal data which is received from the stimulus module. 
//Case statement is used for easier calling of the assertions for the corresponding decode part.

always @(posedge clk) begin
	if(int_read_data[11:9]<3'b110) begin
		case(int_read_data[11:9])
				3'b000:begin assert property(AND_state) else $error("AND_state"); end
				3'b001:begin assert property(TAD_state) else $error("TAD_state"); end
				3'b010:begin assert property(ISZ_state) else $error("ISZ_state"); end
				3'b011:begin assert property(DCA_state) else $error("DCA_state"); end
				3'b100:begin assert property(JMP_state) else $error("JMP_state"); end
				3'b101:begin assert property(JMS_state) else $error("JMS_state"); end
		endcase
	end
	
	if(int_read_data[11:9] == 3'b111) begin
		case(int_read_data)
			12'o7000:begin assert property(NOP_state) else $error("NOP_state"); end
			12'o7001:begin assert property(IAC_state) else $error("IAC_state"); end
			12'o7004:begin assert property(RAL_state) else $error("RAL_state"); end
			12'o7006:begin assert property(RTL_state) else $error("RTL_state"); end
			12'o7010:begin assert property(RAR_state) else $error("RAR_state"); end
			12'o7012:begin assert property(RTR_state) else $error("RTR_state"); end
			12'o7020:begin assert property(CML_state) else $error("CML_state"); end
			12'o7040:begin assert property(CMA_state) else $error("CMA_state"); end
			12'o7041:begin assert property(CLA1_state) else $error("CLA1_state"); end
			12'o7104:begin assert property(CLL_state) else $error("CLL_state"); end
			12'o7200:begin assert property(CLA1_state) else $error("CLA1_state"); end
			12'o7300:begin assert property(CLA_CLL_state) else $error("CLA_CLL_state"); end
			12'o7402:begin assert property(HLT_state) else $error("HLT_state"); end
			12'o7404:begin assert property(OSR_state) else $error("OSR_state"); end
			12'o7410:begin assert property(SKP_state) else $error("SKP_state"); end
			12'o7420:begin assert property(SNL_state) else $error("SNL_state"); end
			12'o7430:begin assert property(SZL_state) else $error("SZL_state"); end
			12'o7440:begin assert property(SZA_state) else $error("SZA_state"); end
			12'o7450:begin assert property(SNA_state) else $error("SNA_state"); end
			12'o7500:begin assert property(SMA_state) else $error("SMA_state"); end
			12'o7510:begin assert property(SPA_state) else $error("SPA_state"); end
			12'o7600:begin assert property(CLA2_state) else $error("CLA2_state"); end
			default:begin assert property(NOP_state) else $error("NOP_state"); end
		endcase

	end
end
endmodule 