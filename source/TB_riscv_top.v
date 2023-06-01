`timescale 1ns / 1ps

// RISC-V top module Testbench
module TB_riscv_top(

    );

reg clk = 0;
reg rstn = 0;

wire opcode_valid;
wire error_datamem_misaligned_access;
wire error_datamem_invalid_address;
wire error_instrmem_misaligned_access;
wire error_instrmem_invalid_address;

riscv_top U0(
    .clk                                (clk)
,   .rstn                               (rstn)
,   .opcode_valid                       (opcode_valid)
,   .error_datamem_misaligned_access    (error_datamem_misaligned_access)
,   .error_datamem_invalid_address      (error_datamem_invalid_address)
,   .error_instrmem_misaligned_access   (error_instrmem_misaligned_access)    
,   .error_instrmem_invalid_address     (error_instrmem_invalid_address)
);

always #4 clk=~clk; 
initial begin
    #30 rstn = 1;   // Reset end
end

endmodule
