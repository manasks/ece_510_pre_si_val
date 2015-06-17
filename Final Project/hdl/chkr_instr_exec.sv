`include "pdp8_pkg.sv"


//`define JMP_CHK
//`define CLA_CLL_CHK
//`define DCA_CHK
//`define JMS_CHK
//`define AND_CHK
//`define TAD_CHK
//`define ISZ_CHK

import pdp8_pkg::*;

module chkr_instr_exec
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
	input [`DATA_WIDTH-1:0] exec_rd_data
);

int stall_count;
int AND_count=0;
int TAD_count=0;
int ISZ_count=0;
int DCA_count=0;
int JMS_count=0;
int JMP_count=0;
int CLA_CLL_count=0;

logic [`DATA_WIDTH:0] tempAcc;
logic [`DATA_WIDTH:0] Acc;
logic [`DATA_WIDTH:0] result;


`ifndef JMP_CHK
property JMP_check_p;
@(posedge clk)
    (stall_count==3 && !stall && pdp_mem_opcode.JMP) |-> (PC_value==pdp_mem_opcode.mem_inst_addr);
endproperty
JMP_check_a: assert property(JMP_check_p) else $error("JMP instruction error");
`endif

`ifndef CLA_CLL_CHK
property CLA_CLL_check_p;
@(posedge clk)
    (stall_count==2 && !stall && pdp_op7_opcode.CLA_CLL) |-> (tempAcc=='0);
endproperty
CLA_CLL_check_a: assert property(CLA_CLL_check_p) else $error("CLA_CLL instruction error");
`endif

`ifndef DCA_CHK
property DCA_check_p;
@(posedge clk)
    (stall_count==3 && !stall && pdp_mem_opcode.DCA) |-> (top.resp_instr_inst.mem_array[pdp_mem_opcode.mem_inst_addr]==top.instr_exec_inst.intAcc);
endproperty
DCA_check_a: assert property(DCA_check_p) else $error("DCA instruction error");
`endif

`ifndef JMS_CHK
property JMS_check_p;
@(posedge clk)
    (stall_count==4 && !stall && pdp_mem_opcode.JMS) |-> (PC_value==pdp_mem_opcode.mem_inst_addr+1);
endproperty
JMS_check_a: assert property(JMS_check_p) else $error("JMS instruction error");
`endif

`ifndef AND_CHK
property AND_check_p;
@(posedge clk)
    (stall_count==5 && !stall && pdp_mem_opcode.AND) |-> (top.instr_exec_inst.intAcc==result);
endproperty
AND_check_a: assert property(AND_check_p) else $error("AND instruction error");
`endif

`ifndef TAD_CHK
property TAD_check_p;
@(posedge clk)
    (stall_count==5 && !stall && pdp_mem_opcode.TAD) |-> (top.instr_exec_inst.intAcc==result);
endproperty
TAD_check_a: assert property(TAD_check_p) else $error("TAD instruction error");
`endif

`ifndef ISZ_CHK
property ISZ_check_p;
@(posedge clk)
    (stall_count==5 && !stall && pdp_mem_opcode.ISZ) |-> (reset_n);
endproperty
ISZ_check_a: assert property(ISZ_check_p) else $error("ISZ instruction error");
`endif

always_ff @(posedge clk)
begin
    if(reset_n)
    begin
        if(!stall)
        begin
            stall_count = 0;
        end
        else
        begin
            stall_count = stall_count+1;
        end
    end
    else
    begin
        stall_count=0;
    end
end

/*
always_comb
begin
    if(new_mem_opcode || new_op7_opcode)
    begin

    end
end
*/

always_comb
begin
    if(stall_count==0)
    begin
        result = '0;
        tempAcc = top.instr_exec_inst.intAcc;
    end
    else if(stall_count==3 && !stall)
    begin
        if(pdp_mem_opcode.JMP)
        begin
            //$display("JMP");
            JMP_count  = JMP_count+1;
        end
        else if(pdp_op7_opcode.CLA_CLL)
        begin
            //$display("CLA_CLL");
            CLA_CLL_count = CLA_CLL_count+1;
        end
    end
    else if(stall_count==4 && !stall)
    begin
        if(pdp_mem_opcode.DCA)
        begin
            //$display("DCA");
            DCA_count = DCA_count+1;
        end
        else if(pdp_mem_opcode.JMS)
        begin
            //$display("JMS");
            JMS_count = JMS_count+1;
        end
        else if(pdp_mem_opcode.AND)
        begin
            tempAcc = top.instr_exec_inst.intAcc;
        end
        else if(pdp_mem_opcode.TAD)
        begin
            tempAcc = top.instr_exec_inst.intAcc;
        end
    end
    else if(stall_count==5 && !stall)
    begin
        if(pdp_mem_opcode.AND)
        begin
            //$display("AND");
            AND_count = AND_count+1;
            result =  tempAcc & exec_rd_data;
        end
        else if(pdp_mem_opcode.TAD)
        begin
            //$display("TAD");
            TAD_count = TAD_count+1;
            result = tempAcc + exec_rd_data;
        end
    end
    else if(stall_count==6 && !stall)
    begin
        if(pdp_mem_opcode.ISZ)
        begin
            //$display("ISZ");
            ISZ_count = ISZ_count+1;
        end
    end
end

int scrbrdfile;
final
begin
    scrbrdfile = $fopen("scrbrd.log","w");
    $fdisplay(scrbrdfile,"AND_count: %d", AND_count);
    $fdisplay(scrbrdfile,"TAD_count: %d", TAD_count);
    $fdisplay(scrbrdfile,"JMP_count: %d", JMP_count);
    $fdisplay(scrbrdfile,"JMS_count: %d", JMS_count);
    $fdisplay(scrbrdfile,"DCA_count: %d", DCA_count);
    $fdisplay(scrbrdfile,"ISZ_count: %d", ISZ_count);
    $fdisplay(scrbrdfile,"CLA_CLL_count: %d", CLA_CLL_count);
    $fclose(scrbrdfile);
end


endmodule
