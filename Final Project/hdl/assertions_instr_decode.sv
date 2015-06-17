`include "pdp8_pkg.sv"
`include "instr_decode.sv"


`define DECODE_CHK1
`define DECODE_CHK2
`define DECODE_CHK3
`define DECODE_CHK4
`define DECODE_CHK5
`define DECODE_CHK6
`define DECODE_CHK7
`define DECODE_CHK8
`define DECODE_CHK9
`define DECODE_CHK10
`define DECODE_CHK11
`define DECODE_CHK12
`define DECODE_CHK13
`define DECODE_CHK14

import pdp8_pkg::*;
module assertions_instr_decode
(
	//Global inputs
	input clk,
	input reset_n,
		
	//From execution unit
	input stall,
	input [`ADDR_WIDTH-1:0] PC_value,
	
	//To memory unit
	input                    ifu_rd_req,
	input  [`ADDR_WIDTH-1:0] ifu_rd_addr,
	
	//From memory unit
	input [`DATA_WIDTH-1:0] ifu_rd_data,
	
	//To Execution unit
    input [`ADDR_WIDTH-1:0] base_addr,
    input pdp_mem_opcode_s pdp_mem_opcode,
    input pdp_op7_opcode_s pdp_op7_opcode,
	input current_state
);

enum{ IDLE,READY,SEND_REQ,DATA_RCVD,INST_DEC,STALL,DONE} next_state; 
//Assertions to check the state transitions.
`ifndef DECODE_CHK1
property IDLE_state_reset;
@(posedge clk)(!reset_n) |-> ( current_state == IDLE);
endproperty
IDLE_state_A	: assert property(IDLE_state_reset) else $error("IDLE_STATE_reset");
`endif

`ifndef DECODE_CHK2
property IDLE_state_trans;
@(posedge clk)
	(current_state==IDLE) |-> $past(current_state==DONE);
endproperty
IDLE_state_transA	: assert property(IDLE_state_trans) else $error("IDLE_STATE_trans");
`endif

`ifndef DECODE_CHK3
property READY_state;
@(posedge clk)
	(current_state==READY) |-> $past((current_state==IDLE) || (current_state==STALL));
endproperty
READY_state_A	: assert property(READY_state) else $error("READY_STATE");
`endif

`ifndef DECODE_CHK4
property SEND_REQ_state;
@(posedge clk)
	(current_state==SEND_REQ) |-> $past((current_state==READY) || current_state == STALL);
endproperty
SEND_REQ_state_A	: assert property(SEND_REQ_state) else $error("SEND_REQ_state");
`endif

`ifndef DECODE_CHK5
property DATA_RCVD_state;
@(posedge clk)
	(current_state==DATA_RCVD) |-> $past((current_state==SEND_REQ));
endproperty
DATA_RCVD_state_A	: assert property(DATA_RCVD_state) else $error("DATA_RCVD_state");
`endif

`ifndef DECODE_CHK6
property INST_DEC_state;
@(posedge clk)
	(current_state==INST_DEC) |-> $past((current_state==DATA_RCVD));
endproperty
INST_DEC_state_A	: assert property(INST_DEC_state) else $error("INST_DEC_state");
`endif

`ifndef DECODE_CHK7
property STALL_state;
@(posedge clk)
	(current_state==STALL) |-> $past((current_state==INST_DEC) || (STALL == 1));
endproperty
STALL_state_A	: assert property(STALL_state) else $error("STALL_state");
`endif

`ifndef DECODE_CHK8
property DONE_state;
@(posedge clk)
	(current_state==DONE) |-> $past((current_state==STALL));
endproperty
DONE_state_A	: assert property(DONE_state) else $error("DONE_state");
`endif


//Assertions to check the decoded output
`ifndef DECODE_CHK9
property AND_state;
@(posedge clk)
	(pdp_mem_opcode == '{1,0,0,0,0,0,ifu_rd_data[8:0]});
endproperty
AND_state_A	: assert property(AND_state) else $error("AND_state");
`endif

`ifndef DECODE_CHK10
property TAD_state;
@(posedge clk)
	(pdp_mem_opcode == '{0,1,0,0,0,0,ifu_rd_data[8:0]});
endproperty
TAD_state_A	: assert property(TAD_state) else $error("TAD_state");
`endif

`ifndef DECODE_CHK11
property ISZ_state;
@(posedge clk)
	(pdp_mem_opcode == '{0,0,1,0,0,0,ifu_rd_data[8:0]});
endproperty
ISZ_state_A	: assert property(ISZ_state) else $error("ISZ_state");
`endif

`ifndef DECODE_CHK12
property DCA_state;
@(posedge clk)
	(pdp_mem_opcode == '{0,0,0,1,0,0,ifu_rd_data[8:0]});
endproperty
DCA_state_A	: assert property(DCA_state) else $error("DCA_state");
`endif

`ifndef DECODE_CHK13
property JMS_state;
@(posedge clk)
	(pdp_mem_opcode == '{0,0,0,0,1,0,ifu_rd_data[8:0]});
endproperty
JMS_state_A	: assert property(JMS_state) else $error("JMS_state");
`endif

`ifndef DECODE_CHK14
property JMP_state;
@(posedge clk)
	(pdp_mem_opcode == '{0,0,0,0,0,1,ifu_rd_data[8:0]});
endproperty
JMP_state_A	: assert property(JMP_state) else $error("JMP_state");
`endif

endmodule