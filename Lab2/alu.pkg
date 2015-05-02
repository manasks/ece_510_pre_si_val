`ifndef DEFS_DONE
`define DEFS_DONE
package mipspkg;

parameter DATAWIDTH = 32;
parameter REGSIZE = 32; // Size of the register
parameter REGADDRSIZE = 5; // Register address size 

//enum for the opcode

typedef enum logic [5:0] { Rtyp 	= '0,
			   J 		= 6'b000010,
			   BEQZ 	= 6'b000100,
			   ADDI 	= 6'b001000,
			   ADDIU 	= 6'b001001,
			   SLTI 	= 6'b011010,
			   ANDI 	= 6'b001100,
			   ORI 		= 6'b001101,
			   XORI 	= 6'b001110,
			   LUI 		= 6'b001111,
			   LW 		= 6'b100011,
			   SW 		= 6'b101011,
			   SUBI 	= 6'b001010 } op_t;

//enum for the alu opcode

typedef enum logic [3:0] { alu_ADD = '0,
			   alu_SUB,
			   alu_SLT,
			   alu_AND = 4'b0100,
			   alu_OR,
			   alu_XOR,
			   alu_LU,
			   alu_regtype = '1 } alu_t;

//enum for the alu funct

typedef enum logic [5:0] { ADD = 6'b100000,
			   ADDU,
			   SUB,
			   SUBU,
			   AND,
			   OR,
			   XOR,
			   NOR,
			   SLT = 6'b101010 } funct_t;

typedef enum logic [5:0] { alucont_ADD = 6'b000010,
			   alucont_SUB = 6'b100010,
			   alucont_SLT,
			   alucont_AND = '0,
			   alucont_OR,
			   alucont_XOR = 6'b000100,
			   alucont_NOR,
			   alucont_LUI = 6'b000110 } alucont_t;


endpackage

import mipspkg::*;

`endif
