`timescale 1ns / 1ps

// RISC-V Program Counter Logic
module riscv_pc (
    input               clk
,   input               rstn
,   input       [ 63:0] pc_next_i

,   output reg  [ 63:0] pc_o  // Program Counter
    );

always @ (posedge clk or negedge rstn) begin
    if (!rstn) begin
        pc_o <= 64'h0; 
    end
    else begin
        pc_o <= pc_next_i;
    end
end

endmodule
