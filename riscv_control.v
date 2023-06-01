`timescale 1ns / 1ps

`include "./riscv_defs.v"

// Control logic
// Generates control signal to determine instruction datapath
module riscv_control(
    // Refer to riscv-spec-20191213, chapter 24
    // to find all base opcode mapping
    input       [ 6:0]  opcode_i

    // Control signal output
,   output reg         alusrc_o        // Use immediate as the second input of the ALU(1), or use RS2 instead(0)
,   output reg         memtoreg_o      // Data memory value to RD register(1), or ALU result to RD register(0)
,   output reg         regwrite_o      // Whether to allow write access to the RD register
,   output reg         memread_o       // Whether to allow read access to the data memory
,   output reg         memwrite_o      // Whether to allow write access to the data memory
,   output reg         branch_o        // Whether it is a branch instruction
,   output reg  [ 1:0] aluop_o         // Determines how the ALU works(00: ADD, 01: SUB, 10: Instruction Specific)    
,   output reg         hasfunct7_o     // Whether opcode has a funct7 field(e.g.,R-type opcode)
,   output reg         opcode_valid_o  // Whether opcode is valid
);

// Datapath settings for each instruction
// Refer to Figure 4.22
always @(*) begin
    // Set default value of opcode_valid_o
    opcode_valid_o = 1'b1;

    // Control signal generation
    case(opcode_i)
        `OP_OP : begin      // R-type Opcode
            alusrc_o    = 1'b0;
            memtoreg_o  = 1'b0;
            regwrite_o  = 1'b1;
            memread_o   = 1'b0;
            memwrite_o  = 1'b0;
            branch_o    = 1'b0;
            aluop_o     = 2'b10;    // ALU?óê 10 Î™ÖÎ†π ?†Ñ?ã¨(Funct ?ïÑ?ìú?óê ?î∞?ùº ?ó∞?Ç∞ ?ã¨?ùºÏß?)
            hasfunct7_o = 1'b1;     // R-type has funct7 field
        end
        `OP_OP_IMM : begin  // I-type Opcode
            alusrc_o    = 1'b1;
            memtoreg_o  = 1'b0;
            regwrite_o  = 1'b1;
            memread_o   = 1'b0;
            memwrite_o  = 1'b0;
            branch_o    = 1'b0;
            aluop_o     = 2'b10;    // ALU?óê 10 Î™ÖÎ†π ?†Ñ?ã¨(Funct ?ïÑ?ìú?óê ?î∞?ùº ?ó∞?Ç∞ ?ã¨?ùºÏß?)
            hasfunct7_o = 1'b0;     // I-type has no funct7 field
        end
        `OP_LOAD : begin    // Load(I-type)
            alusrc_o    = 1'b1;
            memtoreg_o  = 1'b1;
            regwrite_o  = 1'b1;
            memread_o   = 1'b1;
            memwrite_o  = 1'b0;
            branch_o    = 1'b0;
            aluop_o     = 2'b00;    // ALU?óê 00 Î™ÖÎ†π ?†Ñ?ã¨(ADD) - Ï£ºÏÜå Í≥ÑÏÇ∞?óê ?Ç¨?ö©
            hasfunct7_o = 1'b0;     // I-type has no funct7 field
        end
        `OP_STORE : begin   // Store(S-type)
            alusrc_o    = 1'b1;
            memtoreg_o  = 1'bx;
            regwrite_o  = 1'b0;
            memread_o   = 1'b0;
            memwrite_o  = 1'b1;
            branch_o    = 1'b0;
            aluop_o     = 2'b00;    // ALU?óê 00 Î™ÖÎ†π ?†Ñ?ã¨(ADD) - Ï£ºÏÜå Í≥ÑÏÇ∞?óê ?Ç¨?ö©
            hasfunct7_o = 1'b0;     // S-type has no funct7 field
        end
        `OP_BRANCH : begin  // BEQ, BNE, BGE, BLT
            alusrc_o    = 1'b0;
            memtoreg_o  = 1'bx;
            regwrite_o  = 1'b0;
            memread_o   = 1'b0;
            memwrite_o  = 1'b0;
            branch_o    = 1'b1;
            aluop_o     = 2'b01;    // ALU subtract ?ó∞?Ç∞ ?àò?ñâ(Í≤∞Í≥º Í∞ôÏúºÎ©? Zero==1, ?ûë?úºÎ©? lt = 1) - Branch ?åêÎ≥ÑÏóê ?ù¥?ö©
            hasfunct7_o = 1'b0;     // SB-type has no funct7 field
        end
        default : begin     // Invalid Opcode
            alusrc_o    = 1'b0;
            memtoreg_o  = 1'b0;
            regwrite_o  = 1'b0;
            memread_o   = 1'b0;
            memwrite_o  = 1'b0;
            branch_o    = 1'b0;
            aluop_o     = 2'b00;
            hasfunct7_o = 1'b0;
            opcode_valid_o = 1'b0;
        end
    endcase
end

endmodule
