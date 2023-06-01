`timescale 1ns / 1ps

`include "./riscv_defs.v"

// Instruction Memory ROM
module riscv_instrmem(
    input       [ 63:0] address_i
,   output reg  [ 31:0] instruction_o
,   output              error_misaligned_o
,   output              error_invalid_address_o
);

// Core Memory
reg  [ 31:0] mem_block [0:2**`INSTRMEM_WIDTH-1];    // Defines an array that can hold 2**INSTRMEM_WIDTH count 32-bit instructions
wire [ `INSTRMEM_WIDTH-1:0] mem_idx = address_i[`INSTRMEM_WIDTH-1+2:2]; // Converts memory address to corresponding memory block index

// Initialization
integer i;
initial begin
    // Reset to zero
    for (i=0; i<2**`INSTRMEM_WIDTH; i = i+1)
        mem_block[i] = 32'h0;

    // Load initial values
    $display("Loading %s to instruction memory", `INSTRMEM_FILE);
    $readmemh(`INSTRMEM_FILE, mem_block);
end

// Read Operation
always @(*) begin
    if (!error_invalid_address_o & !error_misaligned_o) begin
        instruction_o = mem_block[mem_idx];
    end
    else begin
        instruction_o = 32'h0;
    end
end

assign error_misaligned_o = (address_i[1:0] != 0);  // Memory is misaligned(address should evenly divisible by 4)
assign error_invalid_address_o = (address_i[63:`INSTRMEM_WIDTH+2] != 0);    

endmodule