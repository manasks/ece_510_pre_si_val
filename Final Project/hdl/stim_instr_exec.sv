`include "pdp8_pkg.sv"
import pdp8_pkg::*;

module stim_instr_exec
(
	input clk,
        input reset_n,
	input enable_stimulus,
        input stall,
	output pdp_mem_opcode_s pdp_mem_opcode,
	output pdp_op7_opcode_s pdp_op7_opcode
);

int count_AND;
int count_TAD;
int count_DCA;
int count_ISZ;
int count_JMS;
int count_JMP;
int count_CLA_CLL;


function pdp_mem_opcode_s mem_op(logic[3:0] op, logic[`DATA_WIDTH-1:0] mem_inst_addr);
	case(op)
		`AND: begin
			mem_op = '{1,0,0,0,0,0,mem_inst_addr};
		end
		
		`TAD: begin
			mem_op = '{0,1,0,0,0,0,mem_inst_addr};
		end
		
		`ISZ: begin
			mem_op = '{0,0,1,0,0,0,mem_inst_addr};
		end
		
		`DCA: begin
			mem_op = '{0,0,0,1,0,0,mem_inst_addr};
		end
		
		`JMS: begin
			mem_op = '{0,0,0,0,1,0,mem_inst_addr};
		end
		
		`JMP: begin
			mem_op = '{0,0,0,0,0,1,mem_inst_addr};
		end
	endcase
        //$display("Mem Instr: %b \t mem_inst_addr: %b \t mem_op: %b",op,mem_inst_addr,mem_op);
return (mem_op);
endfunction

function pdp_op7_opcode_s pdp_op7(logic[`OP7_WIDTH-1:0] op7);
	case(op7)
		`NOP: begin
			pdp_op7 = '{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`IAC: begin
			pdp_op7 = '{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`RAL: begin
			pdp_op7 = '{0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`RTL: begin
			pdp_op7 = '{0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`RAR: begin
			pdp_op7 = '{0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`RTR: begin
			pdp_op7 = '{0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`CML: begin
			pdp_op7 = '{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`CMA: begin
			pdp_op7 = '{0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`CIA: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`CLL: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`CLA1: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0};
		end
		
		`CLA_CLL: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0};
		end
		
		`HLT: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0};
		end
		
		`OSR: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0};
		end
		
		`SKP: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0};
		end
		
		`SNL: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0};
		end
		
		`SZL: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0};
		end
		
		`SZA: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0};
		end
		
		`SNA: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0};
		end
		
		`SMA: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0};
		end
		
		`SPA: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0};
		end
		
		`CLA2: begin
			pdp_op7 = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1};
		end
	endcase
		
return (pdp_op7);
endfunction

class RandomInstr;
	
	randc logic[5:0] mem_instr_opcode;
	randc logic[21:0] op7_instr_opcode;
        randc logic [`DATA_WIDTH-1:0] mem_loc;
	//randc pdp_mem_opcode_s pdp_mem_opcode;
	//randc pdp_op7_opcode_s pdp_op7_opcode;
        randc pdp_mem_opcode_s rand_mem_opcode;
        randc pdp_op7_opcode_s rand_op7_opcode;

	constraint mem_instr_const {mem_instr_opcode inside {
					6'b100000,
					6'b010000,
					6'b001000,
					6'b000100,
					6'b000010,
					6'b000001};}

        constraint op7_instr_const {op7_instr_opcode inside{
					22'b1000000000000000000000,
					22'b0100000000000000000000,
					22'b0010000000000000000000,
					22'b0001000000000000000000,
					22'b0000100000000000000000,
					22'b0000010000000000000000,
					22'b0000001000000000000000,
					22'b0000000100000000000000,
					22'b0000000010000000000000,
					22'b0000000001000000000000,
					22'b0000000000100000000000,
					22'b0000000000010000000000,
					22'b0000000000001000000000,
					22'b0000000000000100000000,
					22'b0000000000000010000000,
					22'b0000000000000001000000,
					22'b0000000000000000100000,
					22'b0000000000000000010000,
					22'b0000000000000000001000,
					22'b0000000000000000000100,
					22'b0000000000000000000010,
					22'b0000000000000000000001,
					22'b1000000000000000000000};}

        function pdp_mem_opcode_s form_opcode();
		return {mem_instr_opcode,mem_loc};
	endfunction


	
endclass:RandomInstr

RandomInstr rand_inst;

initial
begin
  //$monitor("pdp_mem_opcode: %b \t pdp_op7_opcode: %b",pdp_mem_opcode,pdp_op7_opcode);
end

always_comb
begin
    if(top.chkr_instr_inst.stall_count==1)
    begin
       if(pdp_mem_opcode.AND)
       begin
            count_AND = count_AND+1;
       end
       else if(pdp_mem_opcode.TAD)
       begin
            count_TAD = count_TAD+1;
       end
       else if(pdp_mem_opcode.DCA)
       begin
            count_DCA = count_DCA+1;
       end
       else if(pdp_mem_opcode.ISZ)
       begin
            count_ISZ = count_ISZ+1;
       end
       else if(pdp_mem_opcode.JMS)
       begin
            count_JMS = count_JMS+1;
       end
       else if(pdp_mem_opcode.JMP)
       begin
            count_JMP = count_JMP+1;
       end
       else if(pdp_op7_opcode.CLA_CLL)
       begin
            count_CLA_CLL = count_CLA_CLL+1;
       end
    end
end

logic [5:0] mem_opcode;
int outfile;

initial
begin
        pdp_mem_opcode = '0;
        pdp_op7_opcode = '0;
        while(!reset_n) @(posedge clk);
  
        $display("Beginning Stimulus for Directed Testing of Memory Reference Instructions");
        //Stimulus for directed testing
	//1. Memory Reference Instructions
        #DELAY @(posedge clk); pdp_mem_opcode = mem_op(`AND, 12'o000); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`AND, 12'o010); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`AND, 12'o100); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`TAD, 12'o000); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`TAD, 12'o010); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`TAD, 12'o100); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`ISZ, 12'o000); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`ISZ, 12'o010); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`ISZ, 12'o100); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`DCA, 12'o000); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`DCA, 12'o010); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`DCA, 12'o100); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`JMS, 12'o000); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`JMS, 12'o010); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`JMS, 12'o100); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`JMP, 12'o000); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`JMP, 12'o010); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	#DELAY @(posedge clk); pdp_mem_opcode = mem_op(`JMP, 12'o100); pdp_op7_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);

        $display("Beginning Stimulus for Directed Testing of Microinstructions");
	//Stimulus for directed testing
	//2. Microinstructions
	#DELAY @(posedge clk); pdp_op7_opcode = pdp_op7(`CLA_CLL); pdp_mem_opcode = '0;
        #DELAY while(stall==1'b1) @(posedge clk);
	
        $display("Beginning Stimulus for Randomized Testing of Memory Reference Instructions");
	//Stimulus for Randomized Testing.
	//1. Memory Reference Instructions
	rand_inst=new();
	for(int i=0;i<100;i++)
	begin
		assert(rand_inst.randomize());
		#DELAY @(posedge clk);
		pdp_mem_opcode = rand_inst.form_opcode(); pdp_op7_opcode = '0;
                #DELAY while(stall==1'b1) @(posedge clk);
	end
	
        $display("Beginning Stimulus for Randomized Testing of Microinstructions");
	//Stimulus for Randomized Testing.
	//2. Microinstructions
	for(int i=0;i<500;i++)
	begin
		assert(rand_inst.randomize());
		#DELAY @(posedge clk);
		pdp_op7_opcode = rand_inst.op7_instr_opcode; pdp_mem_opcode = '0;
                #DELAY while(stall==1'b1) @(posedge clk);
	end
        
        for(int i=0;i<10000;i++)
        begin
                assert(rand_inst.randomize());
                #DELAY @(posedge clk);
                pdp_mem_opcode = rand_inst.rand_mem_opcode; pdp_op7_opcode = '0;
                #DELAY while(stall==1'b1) @(posedge clk);
        end

        for(int i=0;i<10000;i++)
        begin
                assert(rand_inst.randomize());
                #DELAY @(posedge clk);
                pdp_op7_opcode = rand_inst.rand_op7_opcode; pdp_mem_opcode = '0;
                #DELAY while(stall==1'b1) @(posedge clk);
        end

        #DELAY
        #DELAY
        #DELAY

        $display("AND: %d", count_AND);
        $display("TAD: %d", count_TAD);
        $display("JMS: %d", count_JMS);
        $display("DCA: %d", count_DCA);
        $display("JMP: %d", count_JMP);
        $display("ISZ: %d", count_ISZ);
        $display("CLA_CLL: %d", count_CLA_CLL);
        $display("");
      

        $stop;
end

endmodule
