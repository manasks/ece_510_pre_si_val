`include "pdp8_pkg.sv"
`include "instr_exec.sv"

`define EXEC_CHK1
`define EXEC_CHK2
`define EXEC_CHK3
`define EXEC_CHK4
`define EXEC_CHK5
`define EXEC_CHK6
`define EXEC_CHK7
`define EXEC_CHK8
`define EXEC_CHK9
`define EXEC_CHK10
`define EXEC_CHK11
`define EXEC_CHK12
`define EXEC_CHK13
`define EXEC_CHK14
`define EXEC_CHK15
`define EXEC_CHK16
`define EXEC_CHK17
`define EXEC_CHK18

import pdp8_pkg::*;

module assertions_instr_exec
(
	input clk,
	input reset_n,
	input [`ADDR_WIDTH-1:0] base_addr,
	input pdp_mem_opcode_s pdp_mem_opcode,
	input pdp_op7_opcode_s pdp_op7_opcode,
	input stall,
	input [`ADDR_WIDTH-1:0] PC_value,
	input exec_wr_req,
	input [`ADDR_WIDTH-1:0] exec_wr_addr,
	input [`DATA_WIDTH-1:0] exec_wr_data,
	input exec_rd_req,
	input [`ADDR_WIDTH-1:0] exec_rd_addr,
	input [`DATA_WIDTH-1:0] exec_rd_data,
        input current_state
);

 enum { IDLE,
        STALL,
        BRANCH,
        CLA,
        CLA_CLL,
        MEM_RD_REQ,
        DATA_RCVD,
        ADD_ACC_MEM,
        AND_ACC_MEM,
        ISZ_WR_REQ,
        ISZ_UPDT_PC,
        DCA,
        JMS_WR_REQ,
        JMS_UPDT_PC,
        JMP,
        NOP,
        UNSTALL} next_state;

//State Transition Assertions. Checks for valid state transitions.
`ifndef EXEC_CHK1
property StateTransition_IDLE_p;
@(posedge clk)
	(!reset_n) |=> (current_state==IDLE);
endproperty
StateTransition_IDLE_a: assert property(StateTransition_IDLE_p) else $error("StateTransition_IDLE_p");
`endif

`ifndef EXEC_CHK2
property StateTransition_STALL_p;
@(posedge clk)
	(current_state==STALL) |-> $past((current_state==IDLE) || (current_state==UNSTALL) || (current_state==STALL));
endproperty
StateTransition_STALL_a: assert property(StateTransition_STALL_p) else $error("StateTransition_STALL_p");
`endif

`ifndef EXEC_CHK3
property StateTransition_BRANCH_p;
@(posedge clk)
	(current_state==BRANCH) |-> $past(current_state==STALL);
endproperty
StateTransition_BRANCH_a: assert property(StateTransition_BRANCH_p) else $error("StateTransition_BRANCH_p");
`endif

`ifndef EXEC_CHK4
property StateTransition_CLA_p;
@(posedge clk)
	(current_state==CLA) |-> $past(current_state==DCA);
endproperty
StateTransition_CLA_a: assert property(StateTransition_CLA_p) else $error("StateTransition_CLA_p");
`endif

`ifndef EXEC_CHK5
property StateTransition_CLA_CLL_p;
@(posedge clk)
	(current_state==CLA_CLL) |-> $past(current_state==BRANCH);
endproperty
StateTransition_CLA_CLL_a: assert property(StateTransition_CLA_CLL_p) else $error("StateTransition_CLA_CLL_p");
`endif

`ifndef EXEC_CHK6
property StateTransition_MEM_RD_REQ_p;
@(posedge clk)
	(current_state==MEM_RD_REQ) |-> $past(current_state==BRANCH);
endproperty
StateTransition_MEM_RD_REQ_a: assert property(StateTransition_MEM_RD_REQ_p) else $error("StateTransition_MEM_RD_REQ_p");
`endif

`ifndef EXEC_CHK7
property StateTransition_DATA_RCVD_p;
@(posedge clk)
	(current_state==DATA_RCVD) |-> $past(current_state==MEM_RD_REQ);
endproperty
StateTransition_DATA_RCVD_a: assert property(StateTransition_DATA_RCVD_p) else $error("StateTransition_DATA_RCVD_p");
`endif

`ifndef EXEC_CHK8
property StateTransition_ADD_ACC_MEM_p;
@(posedge clk)
	(current_state==ADD_ACC_MEM) |-> $past(current_state==DATA_RCVD);
endproperty
StateTransition_ADD_ACC_MEM_a: assert property(StateTransition_ADD_ACC_MEM_p) else $error("StateTransition_ADD_ACC_MEM_p");
`endif

`ifndef EXEC_CHK9
property StateTransition_AND_ACC_MEM_p;
@(posedge clk)
	(current_state==AND_ACC_MEM) |-> $past(current_state==DATA_RCVD);
endproperty
StateTransition_AND_ACC_MEM_a: assert property(StateTransition_AND_ACC_MEM_p) else $error("StateTransition_AND_ACC_MEM_p");
`endif

`ifndef EXEC_CHK10
property StateTransition_ISZ_WR_REQ_p;
@(posedge clk)
	(current_state==ISZ_WR_REQ) |-> $past(current_state==DATA_RCVD);
endproperty
StateTransition_ISZ_WR_REQ_a: assert property(StateTransition_ISZ_WR_REQ_p) else $error("StateTransition_ISZ_WR_REQ_p");
`endif

`ifndef EXEC_CHK11
property StateTransition_ISZ_UPDT_PC_p;
@(posedge clk)
	(current_state==ISZ_UPDT_PC) |-> $past(current_state==ISZ_WR_REQ);
endproperty
StateTransition_ISZ_UPDT_PC_a: assert property(StateTransition_ISZ_UPDT_PC_p) else $error("StateTransition_ISZ_UPDT_PC_p");
`endif

`ifndef EXEC_CHK12
property StateTransition_DCA_p;
@(posedge clk)
	(current_state==DCA) |-> $past(current_state==BRANCH);
endproperty
StateTransition_DCA_a: assert property(StateTransition_DCA_p) else $error("StateTransition_DCA_p");
`endif

`ifndef EXEC_CHK13
property StateTransition_JMS_WR_REQ_p;
@(posedge clk)
	(current_state==JMS_WR_REQ) |-> $past(current_state==BRANCH);
endproperty
StateTransition_JMS_WR_REQ_a: assert property(StateTransition_JMS_WR_REQ_p) else $error("StateTransition_JMS_WR_REQ_p");
`endif

`ifndef EXEC_CHK14
property StateTransition_JMS_UPDT_PC_p;
@(posedge clk)
	(current_state==JMS_UPDT_PC) |-> $past(current_state==JMS_WR_REQ);
endproperty
StateTransition_JMS_UPDT_PC_a: assert property(StateTransition_JMS_UPDT_PC_p) else $error("StateTransition_JMS_UPDT_PC_p");
`endif

`ifndef EXEC_CHK15
property StateTransition_JMP_p;
@(posedge clk)
	(current_state==JMP) |-> $past(current_state==BRANCH);
endproperty
StateTransition_JMP_a: assert property(StateTransition_JMP_p) else $error("StateTransition_JMP_p");
`endif

`ifndef EXEC_CHK16
property StateTransition_NOP_p;
@(posedge clk)
	(current_state==NOP) |-> $past(current_state==BRANCH);
endproperty
StateTransition_NOP_a: assert property(StateTransition_NOP_p) else $error("StateTransition_NOP_p");
`endif

`ifndef EXEC_CHK17
property StateTransition_UNSTALL_p;
@(posedge clk)
	(current_state==UNSTALL) |-> $past((current_state==CLA) || (current_state==CLA_CLL) ||(current_state==AND_ACC_MEM) ||(current_state==ADD_ACC_MEM) ||(current_state==ISZ_UPDT_PC) ||(current_state==JMS_UPDT_PC) ||(current_state==JMP) ||(current_state==NOP));
endproperty
StateTransition_UNSTALL_a: assert property(StateTransition_UNSTALL_p) else $error("StateTransition_UNSTALL_p");
`endif

//Property to ensure exec_wr_req and exec_rd_req are not turned on at the same time
`ifndef EXEC_CHK18
property exec_wr_rd_req_p;
@(posedge clk)
	(exec_wr_req ^ exec_rd_req) || (!(exec_wr_req && exec_rd_req));
endproperty
exec_wr_rd_req_a: assert property(exec_wr_rd_req_p) else $error("Both READ and WRITE requests are turned ON");
`endif


endmodule
