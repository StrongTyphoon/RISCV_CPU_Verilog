`timescale 1ns / 1ps

`include "./riscv_defs.v"

// RISC-V ALU logic
module riscv_alu(
    // Inputs
    input       [  3:0] alu_control_i
,   input       [ 63:0] alu_a_i
,   input       [ 63:0] alu_b_i

    // Outputs
,   output reg  [ 63:0] alu_result_o
,   output              zero_o  // zero flag
,   output              lt_o    // less-than flag
    );

always @(*) begin
    case (alu_control_i)
    // You can use "`" prefix to use defined macros

    //----------------------------------------------
    // Logical
    //----------------------------------------------
    `ALU_AND:   // AND
        alu_result_o = alu_a_i & alu_b_i;
    `ALU_OR:    // OR
        alu_result_o = alu_a_i | alu_b_i;

    //----------------------------------------------
    // Arithmetic
    //----------------------------------------------
    `ALU_ADD:   // ADD
        alu_result_o = alu_a_i + alu_b_i;
    `ALU_SUB:   // Subtract
        alu_result_o = alu_a_i - alu_b_i;

    //----------------------------------------------
    // Shift
    //----------------------------------------------
    `ALU_SLL:
        alu_result_o = alu_a_i << alu_b_i[5:0];
    `ALU_SRL:
        alu_result_o = alu_a_i >> alu_b_i[5:0];
    default:
        alu_result_o = 64'h0;
    endcase
end

assign zero_o   = (alu_result_o == 0);
assign lt_o     = alu_result_o[63];   // sign bit of alu_result.

endmodule
