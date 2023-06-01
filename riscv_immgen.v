`timescale 1ns / 1ps

`include "./riscv_defs.v"

// Immediate Generator
// Sign-extends immediate field of I, S, SB format to 64-bit
module riscv_immgen(
  input [31:0] instruction_i,
  output reg [63:0] immediate_o
);
  
  wire [6:0] opcode;
  reg [11:0] imm_i;
  reg [11:0] imm_s;
  reg [11:0] imm_sb;

  // Opcode √ﬂ√‚
  assign opcode = instruction_i[6:0];

  always @* begin
  // I-Format   ADDI/ANDI/ORI/SLLI/SLRI 0010011, LD = 0000011   
    if (opcode == 7'b0010011 || opcode == 7'b0000011)
        begin
          imm_i = instruction_i[31:20];
          immediate_o = { {52{imm_i[11]}} , imm_i };
        end
    //S-format SD = 0100011
    else if(opcode == 7'b0100011)   
        begin   
            imm_s = { instruction_i[31:25],instruction_i[11:7] };
            immediate_o = { {52{imm_s[11]}}, imm_s };
        end  
         
    //SB-Format BEQ/BNE/BGE/BLT 1100011, 
    else if(opcode == 7'b1100011)
        begin
          imm_sb = {instruction_i[31],instruction_i[7] ,instruction_i[30:25], instruction_i[11:8] };
          immediate_o = { {52{imm_sb[11]}}, imm_sb };
         end
    //R-Format  
    else
        begin
            immediate_o = 64'b0;
        end
    end
endmodule
