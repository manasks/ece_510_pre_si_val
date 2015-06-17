// =======================================================================
//   Department of Electrical and Computer Engineering
//   Portland State University
//
//   Course name:  ECE 510 - Pre-Silicon Validation
//   Term & Year:  Spring 2015
//   Instructor :  Tareque Ahmad
//
//   Project:      PDP8 Hardware Simulator top level testbench
//                
//
//   Filename:     top.sv
//   Description:  TBD
//   Created by:   Tareque Ahmad
//   Date:         May 03, 2015
//
//   Copyright:    Tareque Ahmad 
// =======================================================================

`include "pdp8_pkg.sv"
import pdp8_pkg::*;
module top;

logic clk;
logic reset_n;

logic stall;
logic [`ADDR_WIDTH-1:0] PC_value;
logic                   ifu_rd_req;
logic [`ADDR_WIDTH-1:0] ifu_rd_addr;
logic [`DATA_WIDTH-1:0] ifu_rd_data;
logic                   exec_rd_req;
logic [`ADDR_WIDTH-1:0] exec_rd_addr;
logic [`DATA_WIDTH-1:0] exec_rd_data;
logic                   exec_wr_req;
logic [`ADDR_WIDTH-1:0] exec_wr_addr;
logic [`DATA_WIDTH-1:0] exec_wr_data;
logic [`DATA_WIDTH-1:0] exec_rd_data_mirror;
logic [`ADDR_WIDTH-1:0] base_addr;
logic new_mem_opcode;
logic new_op7_opcode;

int cycle_count;

pdp_mem_opcode_s pdp_mem_opcode;
pdp_op7_opcode_s pdp_op7_opcode;

enum {
      IDLE,
      INSTR_READ,
      INSTR_DECODE,
      INSTR_EXEC } current_state, next_state;

enum {
      IDLE_STATE,
      CLA_CLL_STATE,
      TAD1_STATE,
      TAD2_STATE,
      DCA_STATE,
      HLT_STATE,
      JMP_STATE } coverage_state,next_instr;


clkgen_driver #(
    .CLOCK_PERIOD(10),
    .RESET_DURATION(500)) clkgen_driver (
    .clk     (clk),
    .reset_n (reset_n)
    );

//DUT Instantiations
memory_pdp      memory_pdp_inst (.*);
instr_decode    instr_decode_inst(.*);

instr_exec instr_exec_inst(
      .clk(clk),
      .reset_n(reset_n),
      .base_addr(base_addr),
      .pdp_mem_opcode(pdp_mem_opcode),
      .pdp_op7_opcode(pdp_op7_opcode),
      .stall(stall),
      .PC_value(PC_value),
      .exec_wr_req(exec_wr_req),
      .exec_wr_addr(exec_wr_addr),
      .exec_wr_data(exec_wr_data),
      .exec_rd_req(exec_rd_req),
      .exec_rd_addr(exec_rd_addr),
      .exec_rd_data(exec_rd_data)
      );


//instr_exec checker, responder and assertions instantiations
bind instr_exec assertions_instr_exec bind_instr_exec(.*);

resp_mem_top resp_instr_inst(
      .clk(clk),
      .exec_wr_addr(exec_wr_addr),
      .exec_wr_data(exec_wr_data),
      .exec_wr_req(exec_wr_req),
      .exec_rd_addr(exec_rd_addr),
      .exec_rd_data(exec_rd_data_mirror),
      .exec_rd_req(exec_rd_req)
      );

chkr_instr_exec chkr_instr_inst(
      .clk(clk),
      .reset_n(reset_n),
      .base_addr(base_addr),
      .pdp_mem_opcode(pdp_mem_opcode),
      .pdp_op7_opcode(pdp_op7_opcode),
      .stall(stall),
      .PC_value(PC_value),
      .exec_wr_req(exec_wr_req),
      .exec_wr_addr(exec_wr_addr),
      .exec_wr_data(exec_wr_data),
      .exec_rd_req(exec_rd_req),
      .exec_rd_addr(exec_rd_addr),
      .exec_rd_data(exec_rd_data_mirror)
      );


assign new_mem_opcode = ( pdp_mem_opcode.AND ||
                          pdp_mem_opcode.TAD ||
                          pdp_mem_opcode.ISZ ||
                          pdp_mem_opcode.DCA ||
                          pdp_mem_opcode.JMS ||
                          pdp_mem_opcode.JMP);

assign new_op7_opcode = ( pdp_op7_opcode.NOP ||
                          pdp_op7_opcode.IAC ||
                          pdp_op7_opcode.RAL ||
                          pdp_op7_opcode.RTL ||
                          pdp_op7_opcode.RAR ||
                          pdp_op7_opcode.RTR ||
                          pdp_op7_opcode.CML ||
                          pdp_op7_opcode.CMA ||
                          pdp_op7_opcode.CIA ||
                          pdp_op7_opcode.CLL ||
                          pdp_op7_opcode.CLA1 ||
                          pdp_op7_opcode.CLA_CLL ||
                          pdp_op7_opcode.HLT ||
                          pdp_op7_opcode.OSR ||
                          pdp_op7_opcode.SKP ||
                          pdp_op7_opcode.SNL ||
                          pdp_op7_opcode.SZL ||
                          pdp_op7_opcode.SZA ||
                          pdp_op7_opcode.SNA ||
                          pdp_op7_opcode.SMA ||
                          pdp_op7_opcode.SPA ||
                          pdp_op7_opcode.CLA2);

//instr_decode checker, respoder and assertions instantiations
chkr_instr_decode chkr_inst_decode(
      .clk(clk),
      .reset_n(reset_n),
      .stall(stall),
      .PC_value(PC_value),
      .ifu_rd_req(ifu_rd_req),
      .ifu_rd_addr(ifu_rd_addr),
      .ifu_rd_data(ifu_rd_data),
      .base_addr(base_addr),
      .pdp_mem_opcode(pdp_mem_opcode),
      .pdp_op7_opcode(pdp_op7_opcode)
      );



//Coverage FSM
int coverage_stats=0;

always_ff @(posedge clk)
begin
    if(!reset_n)
    begin
        coverage_state <= IDLE_STATE;
    end
    else
    begin
        coverage_state <= next_instr;
    end
end

always_ff @(posedge stall)
begin
    if(new_mem_opcode || new_op7_opcode)
    begin    
        //$display("mem_opcode: %b op7_opcode: %b",pdp_mem_opcode,pdp_op7_opcode);
        case(coverage_state)
            IDLE_STATE:
            begin
                //$display("In IDLE");
                if(pdp_op7_opcode.CLA_CLL)
                    next_instr <= CLA_CLL_STATE;
                else
                    next_instr <= IDLE_STATE;
            end

            CLA_CLL_STATE:
            begin
                //$display("In CLA_CLL");
                if(pdp_mem_opcode.TAD)
                    next_instr <= TAD1_STATE;
                else
                    next_instr <= IDLE_STATE;
            end

            TAD1_STATE:
            begin
                //$display("In TAD1");
                if(pdp_mem_opcode.TAD)
                    next_instr <= TAD2_STATE;
                else if(pdp_op7_opcode.CLA_CLL)
                    next_instr <= CLA_CLL_STATE;
                else
                    next_instr <= IDLE_STATE;
            end

            TAD2_STATE:
            begin
                //$display("In TAD2");
                if(pdp_mem_opcode.DCA)
                    next_instr <= DCA_STATE;
                else if(pdp_op7_opcode.CLA_CLL)
                    next_instr <= CLA_CLL_STATE;
                else
                    next_instr <= IDLE_STATE;
            end

            DCA_STATE:
            begin
                //$display("In DCA");
                if(pdp_op7_opcode.HLT)
                    next_instr <= HLT_STATE;
                else if(pdp_op7_opcode)
                    next_instr <= CLA_CLL_STATE;
                else
                    next_instr <= IDLE_STATE;
            end

            HLT_STATE:
            begin
                //$display("In HLT");
                if(pdp_mem_opcode.JMP)
                    next_instr <= JMP_STATE;
                else if(pdp_op7_opcode.CLA_CLL)
                    next_instr <= CLA_CLL_STATE;
                else
                    next_instr <= IDLE_STATE;
            end

            JMP_STATE:
            begin
                //$display("In JMP");
                if(pdp_op7_opcode.CLA_CLL)
                    next_instr <= CLA_CLL_STATE;
                else
                begin
                    coverage_stats = coverage_stats+1;
                    next_instr <= IDLE_STATE;
                end
            end
        endcase
    end
end

final
begin
    $display("Coverage Stats: %d",coverage_stats);
end

int wrfile;
/*
//Always block to trace instruction phases
always_comb
begin
    wrfile = $fopen("instr_stage.log","a");
    case(current_state)
        IDLE:
        begin
            $fdisplay(wrfile,$time,"\t Idle Phase");
            if(ifu_rd_req)
            begin
                next_state <= INSTR_READ;
            end
            else
            begin
                next_state <= IDLE;
            end
        end

        INSTR_READ:
        begin
            $fdisplay(wrfile,$time,"\t Instruction Fetch Phase");
            next_state <= INSTR_DECODE;
        end

        INSTR_DECODE:
        begin
            $fdisplay(wrfile,$time,"\t Instruction Decode Phase");
            if(new_mem_opcode || new_op7_opcode)
            begin
                next_state <= INSTR_EXEC;
            end
            else
            begin
                next_state <= INSTR_EXEC;
            end
        end

        INSTR_EXEC:
        begin
            $fdisplay(wrfile,$time,"\t Instruction Execution Phase");
            if(stall)
            begin
                next_state <= INSTR_EXEC;
            end
            else
            begin
                next_state <= IDLE;
            end
        end
    endcase
    $fclose(wrfile);
end
*/

always_ff @(posedge clk)
begin
    if(!reset_n)
    begin
        current_state <= IDLE;
    end
    else
    begin
        current_state <= next_state;
    end
end


endmodule
