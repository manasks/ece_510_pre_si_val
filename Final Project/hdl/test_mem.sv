// =======================================================================
//   Department of Electrical and Computer Engineering
//   Portland State University
//
//   Course name:  ECE 510 - Pre-Silicon Validation
//   Term & Year:  Spring 2015
//   Instructor :  Tareque Ahmad
//
//   Project:      Hardware implementation of PDP8 
//                 Instruction Set Architecture (ISA) level simulator
//
//   Filename:     memory_pdp.sv
//   Description:  TBD
//   Created by:   Tareque Ahmad
//   Date:         May 08, 2015
//
//   Copyright:    Tareque Ahmad 
// =======================================================================

`include "pdp8_pkg.sv"
module resp_mem_top
  (
   // Global input
   input clk,

   input                    exec_rd_req,
   input  [`ADDR_WIDTH-1:0] exec_rd_addr,
   output [`DATA_WIDTH-1:0] exec_rd_data,

   input                    exec_wr_req,
   input  [`ADDR_WIDTH-1:0] exec_wr_addr,
   input  [`DATA_WIDTH-1:0] exec_wr_data

   );

   reg [`DATA_WIDTH-1:0] int_exec_rd_data;
   reg [11:0] mem_array [0:4095];

   // Fill up the memory with known consecutive data
   integer k;
   initial begin
        for (k=0; k<4096; k=k+1)  begin
           //mem_array[k] = `DATA_WIDTH'bz;
           mem_array[k] = k;
        end
   end

   int file;
   // Fill the memory with values taken from a data file
   initial begin
      file = $fopen(`MEM_FILENAME, "r");
      if (file == 0)
         $display("\nError: Could not find file %s\n",`STUB_FILENAME);
      else
         $readmemh(`MEM_FILENAME,mem_array);
   end

   // Display the contents of STUB memory
   integer l;
   initial begin
        $display("Contents of Mem after reading data file:");
        for (l=0; l<4096; l=l+1)  begin
           $display("%d:%h",l,mem_array[l]);
        end
   end


   //////////////////////////////////////////////////////////////////////////////////////////////
   // Process Exec Write requests
   //
   //////////////////////////////////////////////////////////////////////////////////////////////
   always @(posedge clk) begin
      if (exec_wr_req) begin
         mem_array[exec_wr_addr] = exec_wr_data;
      end
   end

   //////////////////////////////////////////////////////////////////////////////////////////////
   // Process EXEC read requests
   //
   //////////////////////////////////////////////////////////////////////////////////////////////
   always_ff @(posedge clk) begin
      if (exec_rd_req) begin
         int_exec_rd_data    = mem_array[exec_rd_addr];
      end
   end

   assign exec_rd_data      = int_exec_rd_data;

   /*
   // Display the contents of memory
   integer j;

   final begin
        $display("Contents of Mem and the end of the simulation :");
        for (j=0; j<4096; j=j+1)  begin
           $display("%d:%h",j,mem_array[j]);
        end
   end
   */

   int outfile;
   // Fill the memory with values taken from a data file
   final begin
      outfile = $fopen(`STUB_FILENAME, "w");
      if (outfile == 0)
         $display("\nError: Could not find file %s\n",`OUT_FILENAME);
      else
         $writememh(`STUB_FILENAME,mem_array);
   end



endmodule // memory_pdp
