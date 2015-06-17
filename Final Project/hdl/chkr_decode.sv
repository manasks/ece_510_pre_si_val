`include "pdp8_pkg.sv"
import pdp8_pkg::*;
module chkr_instr_decode
(
    //From the stimulus
    input clk,
    input reset_n,
    input stall,
	
    //
    input [`ADDR_WIDTH-1:0] PC_value,
	
	//From the DUT to the responder
    input                   ifu_rd_req,
    input [`ADDR_WIDTH-1:0] ifu_rd_addr,
	
	//From the responder
    input [`DATA_WIDTH-1:0] ifu_rd_data,
    input [`ADDR_WIDTH-1:0] base_addr,
	
	//From the DUT
    input pdp_mem_opcode_s pdp_mem_opcode,
    input pdp_op7_opcode_s pdp_op7_opcode
);

// implement the functionality

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
logic and_instr;
logic tad;
logic isz;
logic dca;
logic jms;
logic jmp;

logic nop;
logic iac;
logic ral;
logic rtl;
logic rar;
logic rtr;
logic cml;
logic cma;
logic cia;
logic cll;
logic cla1;
logic cla_cll;
logic hlt;
logic osr;
logic skp;
logic snl;
logic szl;
logic sza;
logic sna;
logic sma;
logic spa;
logic cla2;


//Memory Reference Instruction Checkers
`ifndef AND_CHK1
property AND_CHK_p;
@(posedge clk)
	(and_instr) |-> (pdp_mem_opcode=='{1,0,0,0,0,0,ifu_rd_data[8:0]});
endproperty
AND_CHK_a: assert property(AND_CHK_p) else $error("AND_CHK_p");
`endif

`ifndef TAD_CHK1
property TAD_CHK_p;
@(posedge clk)
	(tad) |-> (pdp_mem_opcode=='{0,1,0,0,0,0,ifu_rd_data[8:0]});
endproperty
TAD_CHK_a: assert property(TAD_CHK_p) else $error("TAD_CHK_p");
`endif

`ifndef ISZ_CHK1
property ISZ_CHK_p;
@(posedge clk)
	(isz) |-> (pdp_mem_opcode=='{0,0,1,0,0,0,ifu_rd_data[8:0]});
endproperty
ISZ_CHK_a: assert property(ISZ_CHK_p) else $error("ISZ_CHK_p");
`endif

`ifndef DCA_CHK1
property DCA_CHK_p;
@(posedge clk)
	(dca) |-> (pdp_mem_opcode=='{0,0,0,1,0,0,ifu_rd_data[8:0]});
endproperty
DCA_CHK_a: assert property(DCA_CHK_p) else $error("DCA_CHK_p");
`endif

`ifndef JMS_CHK1
property JMS_CHK_p;
@(posedge clk)
	(jms) |-> (pdp_mem_opcode=='{0,0,0,0,1,0,ifu_rd_data[8:0]});
endproperty
JMS_CHK_a: assert property(JMS_CHK_p) else $error("JMS_CHK_p");
`endif

`ifndef JMP_CHK1
property JMP_CHK_p;
@(posedge clk)
	(jmp) |-> (pdp_mem_opcode=='{0,0,0,0,0,1,ifu_rd_data[8:0]});
endproperty
JMP_CHK_a: assert property(JMP_CHK_p) else $error("JMP_CHK_p");
`endif


//MicroInstructions Checkers
`ifndef NOP_CHK1
property NOP_CHK_p;
@(posedge clk)
        (nop) |-> (pdp_op7_opcode=='{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
NOP_CHK_a: assert property(NOP_CHK_p) else $error("NOP_CHK_p");
`endif

`ifndef IAC_CHK1
property IAC_CHK_p;
@(posedge clk)
        (iac) |-> (pdp_op7_opcode=='{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
IAC_CHK_a: assert property(IAC_CHK_p) else $error("IAC_CHK_p");
`endif

`ifndef RAL_CHK1
property RAL_CHK_p;
@(posedge clk)
        (ral) |-> (pdp_op7_opcode=='{0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
RAL_CHK_a: assert property(RAL_CHK_p) else $error("RAL_CHK_p");
`endif

`ifndef RTL_CHK1
property RTL_CHK_p;
@(posedge clk)
        (rtl) |-> (pdp_op7_opcode=='{0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
RTL_CHK_a: assert property(RTL_CHK_p) else $error("RTL_CHK_p");
`endif

`ifndef RAR_CHK1
property RAR_CHK_p;
@(posedge clk)
        (rar) |-> (pdp_op7_opcode=='{0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
RAR_CHK_a: assert property(RAR_CHK_p) else $error("RAR_CHK_p");
`endif

`ifndef RTR_CHK1
property RTR_CHK_p;
@(posedge clk)
        (rtr) |-> (pdp_op7_opcode=='{0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
RTR_CHK_a: assert property(RTR_CHK_p) else $error("RTR_CHK_p");
`endif

`ifndef CML_CHK1
property CML_CHK_p;
@(posedge clk)
        (cml) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
CML_CHK_a: assert property(CML_CHK_p) else $error("CML_CHK_p");
`endif

`ifndef CMA_CHK1
property CMA_CHK_p;
@(posedge clk)
        (cma) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
CMA_CHK_a: assert property(CMA_CHK_p) else $error("CMA_CHK_p");
`endif

`ifndef CIA_CHK1
property CIA_CHK_p;
@(posedge clk)
        (cia) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
CIA_CHK_a: assert property(CIA_CHK_p) else $error("CIA_CHK_p");
`endif

`ifndef CLL_CHK1
property CLL_CHK_p;
@(posedge clk)
        (cll) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0});
endproperty
CLL_CHK1_a: assert property(CLL_CHK_p) else $error("CLL_CHK_p");
`endif

`ifndef CLA1_CHK1
property CLA1_CHK_p;
@(posedge clk)
        (cla1) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0});
endproperty
CLA1_CHK_a: assert property(CLA1_CHK_p) else $error("CLA1_CHK_p");
`endif

`ifndef CLA_CLL_CHK1
property CLA_CLL_CHK_p;
@(posedge clk)
        (cla_cll) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0});
endproperty
CLA_CLL_CHK_a: assert property(CLA_CLL_CHK_p) else $error("CLA_CLL_CHK_p: %b",pdp_op7_opcode);
`endif

`ifndef HLT_CHK1
property HLT_CHK_p;
@(posedge clk)
        (hlt) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0});
endproperty
HLT_CHK_a: assert property(HLT_CHK_p) else $error("HLT_CHK_p");
`endif

`ifndef OSR_CHK1
property OSR_CHK_p;
@(posedge clk)
        (osr) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0});
endproperty
OSR_CHK_a: assert property(OSR_CHK_p) else $error("OSR_CHK_p");
`endif

`ifndef SKP_CHK1
property SKP_CHK_p;
@(posedge clk)
        (skp) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0});
endproperty
SKP_CHK_a: assert property(SKP_CHK_p) else $error("SKP_CHK_p");
`endif

`ifndef SNL_CHK1
property SNL_CHK_p;
@(posedge clk)
        (snl) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0});
endproperty
SNL_CHK_a: assert property(SNL_CHK_p) else $error("SNL_CHK_p");
`endif

`ifndef SZL_CHK1
property SZL_CHK_p;
@(posedge clk)
        (szl) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0});
endproperty
SZL_CHK_a: assert property(SZL_CHK_p) else $error("SZL_CHK_p");
`endif

`ifndef SZA_CHK1
property SZA_CHK_p;
@(posedge clk)
        (sza) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0});
endproperty
SZA_CHK_a: assert property(SZA_CHK_p) else $error("SZA_CHK_p");
`endif

`ifndef SNA_CHK1
property SNA_CHK_p;
@(posedge clk)
        (sna) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0});
endproperty
SNA_CHK_a: assert property(SNA_CHK_p) else $error("SNA_CHK_p");
`endif

`ifndef SMA_CHK1
property SMA_CHK_p;
@(posedge clk)
        (sma) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0});
endproperty
SMA_CHK_a: assert property(SMA_CHK_p) else $error("SMA_CHK_p");
`endif

`ifndef SPA_CHK1
property SPA_CHK_p;
@(posedge clk)
        (spa) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0});
endproperty
SPA_CHK_a: assert property(SPA_CHK_p) else $error("SPA_CHK_p");
`endif

`ifndef CLA2_CHK1
property CLA2_CHK_p;
@(posedge clk)
        (cla2) |-> (pdp_op7_opcode=='{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1});
endproperty
CLA2_CHK_a: assert property(CLA2_CHK_p) else $error("CLA2_CHK_p");
`endif


always_comb
begin
    tad=0;
    and_instr=0;
    isz=0;
    dca=0;
    jms=0;
    jmp=0;
    
    nop=0;
    iac=0;
    ral=0;
    rtl=0;
    rar=0;
    rtr=0;
    cml=0;
    cma=0;
    cia=0;
    cll=0;
    cla1=0;
    cla_cll=0;
    hlt=0;
    osr=0;
    skp=0;
    snl=0;
    szl=0;
    sza=0;
    sna=0;
    sma=0;
    spa=0;
    cla2=0;

    if(new_mem_opcode || new_op7_opcode)
	begin
	    if (ifu_rd_data[`DATA_WIDTH-1:`DATA_WIDTH-3] < 6)
	    begin
	        case(ifu_rd_data[`DATA_WIDTH-1:`DATA_WIDTH-3])
		    `AND:
                    begin
                        and_instr = 1; 
                    end
		    
                    `TAD:
                    begin
                        tad = 1;
                    end
                    
                    `ISZ:
                    begin
                        isz = 1;
                    end

                    `DCA:
                    begin
                        dca = 1;
                    end

                    `JMS:
                    begin
                        jms = 1;
                    end

                    `JMP:
                    begin
                        jmp = 1;
                    end
		endcase
	    end
	    else if (ifu_rd_data[`DATA_WIDTH-1:`DATA_WIDTH-3] == 7)
	    begin
	        case(ifu_rd_data)
		    `NOP:
                    begin
                        nop = 1;    
                    end

                    `IAC:
                    begin
                        iac = 1;
                    end

                    `RAL:
                    begin
                        ral = 1;
                    end

                    `RTL:
                    begin
                        rtl = 1;
                    end

                    `RAR:
                    begin
                        rar = 1;
                    end

                    `RTR:
                    begin
                        rtr = 1;
                    end

                    `CML:
                    begin
                        cml = 1;
                    end

                    `CMA:
                    begin
                        cma = 1;
                    end

                    `CIA:
                    begin
                        cia = 1;
                    end

                    `CLL:
                    begin
                        cll = 1;
                    end

                    `CLA1:
                    begin
                        cla1 = 1;
                    end

                    `CLA_CLL:
                    begin
                        cla_cll = 1;
                    end

                    `HLT:
                    begin
                        hlt = 1;
                    end

                    `OSR:
                    begin
                        osr = 1;
                    end

                    `SKP:
                    begin
                        skp = 1;
                    end

                    `SNL:
                    begin
                        snl = 1;
                    end

                    `SZL:
                    begin
                        szl = 1;
                    end

                    `SZA:
                    begin
                        sza = 1;
                    end

                    `SNA:
                    begin
                        sna = 1;
                    end

                    `SMA:
                    begin
                        sma = 1;
                    end

                    `SPA:
                    begin
                        spa = 1;
                    end

                    `CLA2:
                    begin
                        cla2 = 1;
                    end
                endcase
	    end
	    else
	    begin
	       /* case()
			
		endcase*/
	    end
	end
end

endmodule 
