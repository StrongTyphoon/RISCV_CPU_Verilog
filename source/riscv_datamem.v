`timescale 1ns / 1ps

`include "./riscv_defs.v"

// Data memory
module riscv_datamem(
    input clk
,   input       [ 63:0] address_i       // Memory address to read
,   input               re_i            // Read enable. "MemRead" in the textbook.
,   input               we_i            // Write enable. "MemWrite" in the textbook.
,   input       [ 63:0] write_data_i    // Data to write
,   output reg  [ 63:0] read_data_o     // Memory output
,   output              error_misaligned_o
,   output              error_invalid_address_o
);

reg  [ 63:0] mem_block [0:2**`DATAMEM_WIDTH-1];  // Defines an array that can hold 2**DATA_WIDTH count 64-bit data
wire [ `INSTRMEM_WIDTH-1:0] mem_idx = address_i[`INSTRMEM_WIDTH-1+3:3]; // Converts memory address to corresponding memory block index

integer i;
initial begin
    // Reset to zero
    for (i=0; i<2**`DATAMEM_WIDTH; i = i+1)
        mem_block[i] = 64'h0;

    // Load initial values
    $display("Loading %s to data memory", `DATAMEM_FILE);
    $readmemh(`DATAMEM_FILE, mem_block);
end

// Write Operation
// Clock needed to write
always @ (posedge clk) begin
    if (we_i) begin
        mem_block[mem_idx] <= write_data_i;
    end
end

// Read Operation
always @(*) begin
    if (re_i & !error_invalid_address_o & !error_misaligned_o) begin
        read_data_o = mem_block[mem_idx];
    end
    else begin
        read_data_o = 64'h0;
    end
end

assign error_misaligned_o = (re_i | we_i) & (address_i[2:0] != 0);  // Memory is misaligned(address should evenly divisible by 8)
assign error_invalid_address_o = (re_i | we_i) & (address_i[63:`DATAMEM_WIDTH+3] != 0);

endmodule
