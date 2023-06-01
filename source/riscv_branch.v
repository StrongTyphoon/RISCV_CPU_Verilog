`timescale 1ns / 1ps

// RISC-V Branch logic
module riscv_branch(
    input              ctrl_branch_i   // Signal indicating whether it is a branch instruction
,   input       [ 2:0] funct3_i        // funct3 field of branch instruction
,   input              zero_i          // less-than flag
,   input              lt_i            // zero flag

,   output reg         pcsrc_o         // Signal indicating whether to branch
);

// Generates control signal according to branch instruction type
always @(*) begin
    pcsrc_o = 0;
    if (ctrl_branch_i) begin    // If it is branch instruction
        case (funct3_i)         // instruction type is determined by funct3 field
            3'b000: pcsrc_o = zero_i;   // BEQ
            3'b001: pcsrc_o = !zero_i;  // BNE
            3'b100: pcsrc_o = lt_i;     // BLT
            3'b101: pcsrc_o = !lt_i;    // BGE
        endcase
    end
end

endmodule
