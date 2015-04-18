// =======================================================================
//   Filename:     building_blocks.v
//   Created by:   Tareque Ahmad
//   Date:         Feb 20, 2015
//   ECE 510: Pre-Silicon Validation
//   Term:    SPring 2015
//   This file contains the basic building blocks for Lab0
//
// =======================================================================

`timescale 1ns/1ps

// 1 bit full adder
module full_adder_1bit_struct
  (

   input                     Ain,
   input                     Bin,
   input                     Cin,

   output                    Sum,
   output                    Cout
  );

  assign Sum  = Ain ^ Bin ^ Cin;
  assign Cout = (Ain & Bin) | (Bin & Cin) | (Cin & Ain);

endmodule // adder_1bit_sturct

// 1 bit full subtractor
module full_sub_1bit_struct
  (

   input                     Xin,
   input                     Yin,
   input                     BorrowIn,

   output                    Diff,
   output                    BorrowOut 
  );

  assign Diff      = Xin ^ Yin ^ BorrowIn;
  assign BorrowOut = (~Xin & Yin) | (~Xin & BorrowIn) | (Yin & BorrowIn);

endmodule // full_sub_1bit_struct

// 1 bit parity generator
module parity_gen_1bit_struct
  (

   input                     Ain,
   input                     Bin,

   output                    ParityOut 
  );

  assign ParityOut = (~Ain & Bin) | (Ain & ~Bin);

endmodule // parity_gen_1bit_struct

// 1 bit comparator
module comparator_1bit_struct
  (

   input                     Ain,
   input                     Bin,

   output                    CompOut 
  );

  assign CompOut = (~Ain & ~Bin) | (Ain & Bin);

endmodule // comparator_1bit_struct

// Parameterized Full adder
module full_adder_generic(Ain, Bin, Cin, Sum, Cout);

  parameter WIDTH = 2;

  input [WIDTH-1:0] Ain;
  input [WIDTH-1:0] Bin;
  input             Cin;

  output [WIDTH-1:0] Sum;
  output             Cout;

  wire [WIDTH:0] temp_cout;

  assign temp_cout[0] = Cin;

  generate
     genvar i;
     for (i=0; i<WIDTH; i=i+1) begin: ADDER
         full_adder_1bit_struct FA_1bit(
            .Ain (Ain[i]),
            .Bin (Bin[i]),
            .Cin (temp_cout[i]),
            .Sum  (Sum[i]),
            .Cout (temp_cout[i+1])
         );
     end
  endgenerate

  assign Cout = temp_cout[WIDTH];

endmodule // full_adder_generic

// Parameterized Full subtractor
module full_sub_generic(Xin, Yin, BorrowIn, Diff, BorrowOut);

  parameter WIDTH = 2;

  input [WIDTH-1:0] Xin;
  input [WIDTH-1:0] Yin;
  input             BorrowIn;

  output [WIDTH-1:0] Diff;
  output             BorrowOut;

  wire [WIDTH:0] temp_borrow;

  assign temp_borrow[0] = BorrowIn;

  generate
     genvar i;
     for (i=0; i<WIDTH; i=i+1) begin: ADDER
         full_sub_1bit_struct SUB_1bit(
            .Xin       (Xin[i]),
            .Yin       (Yin[i]),
            .BorrowIn  (temp_borrow[i]),
            .Diff      (Diff[i]),
            .BorrowOut (temp_borrow[i+1])
         );
     end
  endgenerate

  assign BorrowOut = temp_borrow[WIDTH];

endmodule // full_sub_generic

// Parameterized Parity generator
module parity_gen_generic(Ain, Bin, ParityOut);

  parameter WIDTH = 2;

  input [WIDTH-1:0] Ain;
  input [WIDTH-1:0] Bin;

  output [WIDTH-1:0] ParityOut;

  wire [WIDTH-1:0] temp_pout;

  generate
     genvar i;
     for (i=0; i<WIDTH; i=i+1) begin: PARITY
         parity_gen_1bit_struct PARITY_1bit(
            .Ain        (Ain[i]),
            .Bin        (Bin[i]),
            .ParityOut  (temp_pout[i])
         );
     end
  endgenerate

  assign ParityOut = temp_pout;

endmodule // parity_gen_generic

// Parameterized comparator
module comparator_generic(Ain, Bin, CompOut);

  parameter WIDTH = 2;

  input [WIDTH-1:0] Ain;
  input [WIDTH-1:0] Bin;

  output [WIDTH-1:0] CompOut;

  wire [WIDTH-1:0] temp_cout;

  generate
     genvar i;
     for (i=0; i<WIDTH; i=i+1) begin: COMPARATOR
         comparator_1bit_struct COMPARATOR_1bit(
            .Ain        (Ain[i]),
            .Bin        (Bin[i]),
            .CompOut  (temp_cout[i])
         );
     end
  endgenerate

  assign CompOut = temp_cout;

endmodule // comparator_generic

