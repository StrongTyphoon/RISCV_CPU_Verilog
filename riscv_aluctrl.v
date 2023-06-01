`timescale 1ns / 1ps

`include "./riscv_defs.v"

// ALU control logic
// Determines instruction-specific operation of ALU when ALUop=2'b10
module riscv_aluctrl(
    input       [ 1:0] aluop_i       // A signal determines how the ALU works(00: ADD, 01: SUB, 10: Instruction Specific)
,   input              funct7_i      // 5th bit of FUNCT7 field that determines specific ALU operation. 
,   input       [ 2:0] funct3_i      // FUNCT3 field that determines the specific ALU operation. 
,   input              hasfunct7_i   // Whether opcode has a funct7 field(e.g.,R-type opcode)
,   output reg  [ 3:0] alu_control_o // ALU control logic output
);

// funct7 field is used only when it is available in current instruction
wire funct = {funct7_i & hasfunct7_i, funct3_i};

always @(*) begin
    // Refer to COD-RISCV Figure 4.13
    // Truth table using don't care
    case(aluop_i)
        2'b00: alu_control_o = `ALU_ADD;    // ALU ADD
        2'b01: alu_control_o = `ALU_SUB;    // ALU SUB
        2'b10:  // Instruction-specific ALU operation
            case(funct) // ALU operation is determined by funct field
                4'b0000: alu_control_o = `ALU_ADD;
                4'b1000: alu_control_o = `ALU_SUB;
                4'b0111: alu_control_o = `ALU_AND;
                4'b0110: alu_control_o = `ALU_OR;
                4'b0001: alu_control_o = `ALU_SLL;
                4'b0101: alu_control_o = `ALU_SRL;
                default: alu_control_o = 4'b0000;
            endcase
        default:
            alu_control_o = 4'b0000;
    endcase
end

endmodule
