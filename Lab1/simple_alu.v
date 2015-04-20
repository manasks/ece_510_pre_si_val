// =======================================================================
//   Filename:     simple_alu.v
//   Created by:   Tareque Ahmad
//   Date:         Feb 20, 2015
//   ECE 510: Pre-Silicon Validation
//   Lab 0
//   This is a simple FSM based ALU that supports 4 basic operations
//   based on two operands and an opcode
//
// =======================================================================

// Let's define some defines
`define DATA_WIDTH 8
`define RESET  9'b000000001
`define IDLE   9'b000000010
`define DATA_A 9'b000000100
`define DATA_B 9'b000001000
`define ADD    9'b000010000
`define SUB    9'b000100000
`define PAR    9'b001000000
`define COMP   9'b010000000
`define DONE   9'b100000000

// Define the module
module simple_alu
  (
   // Global inputs
   input                     clk,
   input                     reset_n,

   // Control inputs
   input                     opcode_valid,
   input                     opcode,

   // Data input
   input [`DATA_WIDTH-1:0]   data,

   // Outputs
   output                    done,
   output                    overflow,
   output  [`DATA_WIDTH-1:0] result

   );

   // Define some parameters
   parameter OPCODE_ADD = 2'b00;
   parameter OPCODE_SUB = 2'b01;
   parameter OPCODE_PAR = 2'b10;
   parameter OPCODE_COMP = 2'b11;

   // Define registers for FSM
   reg [8:0] current_state;
   reg [8:0] next_state;

   // Define internal registers for data
   reg [`DATA_WIDTH-1:0] int_data_a;
   reg [`DATA_WIDTH-1:0] int_data_b;
   reg [1:0]             int_opcode;

   // Define internal registers for outputs
   reg                 int_done;
   reg                 int_overflow;
   reg [`DATA_WIDTH:0] int_result;

   // Define internal registers for outputs from full adder
   wire [`DATA_WIDTH-1:0] adder_sum;
   wire                   adder_cout;

   // Define internal registers for outputs from full subtractor
   wire [`DATA_WIDTH-1:0] sub_diff;
   wire                   sub_borrowout;

   // Define internal registers for outputs from parity generator
   wire [`DATA_WIDTH-1:0] parity_out;

   // Define internal registers for outputs from comparator
   wire [`DATA_WIDTH-1:0] comp_out;

   // Instantiate full adder
   full_adder_generic #(.WIDTH(`DATA_WIDTH)) FA_ALU (.Ain(int_data_a),
                                                     .Bin(int_data_b),
                                                     .Cin(1'b0),
                                                     .Sum(adder_sum),
                                                     .Cout(adder_cout));

   // Instantiate full subtractor
   full_sub_generic #(.WIDTH(`DATA_WIDTH)) SUB_ALU (.Xin(int_data_a),
                                                    .Yin(int_data_b),
                                                    .BorrowIn(1'b0),
                                                    .Diff(sub_diff),
                                                    .BorrowOut(sub_borrowout));

   // Instantiate parity generator
   parity_gen_generic #(.WIDTH(`DATA_WIDTH)) PAR_ALU (.Ain(int_data_a),
                                                      .Bin(int_data_b),
                                                      .ParityOut(parity_out));

   // Instantiate comparator
   comparator_generic #(.WIDTH(`DATA_WIDTH)) COMP_ALU (.Ain(int_data_a),
                                                       .Bin(int_data_b),
                                                       .CompOut(comp_out));

   // always block to drive FSM
   always @(posedge clk or negedge reset_n or current_state) 
      if (!reset_n) current_state = `RESET;
      else          current_state = next_state;

   // Always block to define next state and calculate outputs
   always @(posedge clk) begin
      //$display("SIMPLE_ALU - opcode: %h \t opcode_valid: %h \t data: %h \t result: %h \t overflow: %h \t done: %h \t current_state: %h",opcode,opcode_valid,data,result,overflow,done,current_state);
      //$display("int_data_a: %h \t int_data_b: %h", int_data_a, int_data_b);
      case (current_state)

         // This is the dafault state when the FSM is in reset
         // The FSM stays in this state as long as reset_n is asserted
         // otherwise, it jumps to IDLE state
         // Outputs are cleared in this state
         //
         `RESET: begin
                    // Clear the outputs
                    int_opcode   = 2'b00;
                    int_done     = 0;
                    int_overflow = 0;
                    int_data_a   = {`DATA_WIDTH{1'b0}};
                    int_data_b   = {`DATA_WIDTH{1'b0}};
                    int_result   = {`DATA_WIDTH{1'b0}};

                    if (!reset_n) begin
                       next_state = `RESET;
                    end else begin
                       next_state = `IDLE;
                    end

                 end

         // This is the dafault state when there is no valid opcode in the machine.
         // The FSM stays in this state as long as opcode_valid is de-asserted,
         // otherwise it jumps to DATA_A state
         // Outputs are cleared in this state
         //
         `IDLE: begin
                  // Clear the outputs
                  int_opcode   = 2'b00;
                  int_done     = 0;
                  int_overflow = 0;
                  int_data_a   = {`DATA_WIDTH{1'b0}};
                  int_data_b   = {`DATA_WIDTH{1'b0}};
                  int_result   = {`DATA_WIDTH{1'b0}};

                  if (opcode_valid) begin
                     next_state = `DATA_A;
                  end else begin
                     next_state = `IDLE;

                  end

               end

         // First operand (data) and bit[0] of opcode is latched in this state
         // The FSM does not stay in this state for more than one clock
         // It makes an unconditional jump to DATA_B state from here
         // Outputs are not valid at this state (yet)
         //
         `DATA_A: begin
                  // Clear the outputs
                  int_done     = 0;
                  int_overflow = 0;
                  int_result   = {`DATA_WIDTH{1'b0}};

                  if (!opcode_valid) begin
                     next_state = `IDLE;
                  end else begin

                     // Latch the data
                     int_data_a    = data;
                     int_opcode[0] = opcode;

                     next_state = `DATA_B;
                  end

               end

         // Second operand (data) and bit[1] of opcode is latched in this state
         // The FSM does not stay in this state for more than one clock
         // It makes an conditional jump to one of the operational states from
         // here
         // Outputs are still not valid at this state
         //
         `DATA_B: begin
                  // Clear the outputs
                  int_done     = 0;
                  int_overflow = 0;
                  int_result   = {`DATA_WIDTH{1'b0}};

                  if (!opcode_valid) begin
                     next_state = `IDLE;
                  end else begin

                     // Latch the data
                     int_data_b    = data;
                     int_opcode[1] = opcode;

                     if (int_opcode == OPCODE_ADD)
                        next_state = `ADD;
                     else if (int_opcode == OPCODE_SUB)
                        next_state = `SUB;
                     else if (int_opcode == OPCODE_PAR)
                        next_state = `PAR;
                     else if (int_opcode == OPCODE_COMP)
                        next_state = `COMP;
                     else
                        next_state = `IDLE;
                  end

               end

         // This is an individual operation state
         // Outputs are derived from full adder
         // The FSM does not stay in this state for more than one clock
         // It makes an unconditional jump to DONE state from here
         //
         `ADD: begin
                   int_result   = adder_sum;
                   int_overflow = adder_cout;

                   next_state = `DONE;
                end

         // This is an individual operation state
         // Outputs are derived from full subtractor
         // The FSM does not stay in this state for more than one clock
         // It makes an unconditional jump to DONE state from here
         //
         `SUB: begin
                   int_result   = sub_diff;
                   int_overflow = sub_borrowout;

                   next_state   = `DONE;
                end

         // This is an individual operation state
         // Outputs are derived from parity generator
         // The FSM does not stay in this state for more than one clock
         // It makes an unconditional jump to DONE state from here
         //
         `PAR: begin
                   int_result   = parity_out;
                   int_overflow = ^parity_out;

                   next_state   = `DONE;
                end

         // This is an individual operation state
         // Outputs are derived from comparator
         // The FSM does not stay in this state for more than one clock
         // It makes an unconditional jump to DONE state from here
         //
         `COMP: begin
                   int_result   = comp_out;
                   int_overflow = 0;

                   next_state   = `DONE;
                end

         // This is final state for an individual operation
         // Outputs are still valid here
         // The FSM WILL stay in this state as long as opcode_valid is asserted.
         // It will jump to IDLE state if opcode_valid is de-asserted
         //
         `DONE: begin
                    // done output is assrted here
                    int_done   = 1;

                    if (opcode_valid) begin
                      next_state = `DONE;
                    end else begin
                      next_state = `IDLE;
                    end

                end
      endcase
   end


   // Continuous assignment for the outputs
   assign done     = int_done;
   assign overflow = int_overflow;
   assign result   = int_result[`DATA_WIDTH-1:0];

endmodule //  simple_alu

