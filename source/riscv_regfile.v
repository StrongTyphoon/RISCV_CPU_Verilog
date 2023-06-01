`timescale 1ns / 1ps

// RISC-V Register file
module riscv_regfile (
    // Inputs
    input               clk
,   input               rstn
,   input               we_i               // Write enable. "RegWrite" in textbook
,   input       [  4:0] write_register_i   // Index of the destination register(rd) to be written
,   input       [ 63:0] write_data_i       // Data to be written to the destination register(rd)
,   input       [  4:0] read_register_1_i  // Index of the 1st source register(rs1) to read
,   input       [  4:0] read_register_2_i  // Index of the 2nd source register(rs2) to read

    // Outputs
,   output reg  [ 63:0] read_data_1_o
,   output reg  [ 63:0] read_data_2_o
    );

/* Registers */
// value of x0 is always zero, write is ignored
// x0 == 0
reg [63:0] x1_r;
reg [63:0] x2_r;
reg [63:0] x3_r;
reg [63:0] x4_r;
reg [63:0] x5_r;
reg [63:0] x6_r;
reg [63:0] x7_r;
reg [63:0] x8_r;
reg [63:0] x9_r;
reg [63:0] x10_r;
reg [63:0] x11_r;
reg [63:0] x12_r;
reg [63:0] x13_r;
reg [63:0] x14_r;
reg [63:0] x15_r;
reg [63:0] x16_r;
reg [63:0] x17_r;
reg [63:0] x18_r;
reg [63:0] x19_r;
reg [63:0] x20_r;
reg [63:0] x21_r;
reg [63:0] x22_r;
reg [63:0] x23_r;
reg [63:0] x24_r;
reg [63:0] x25_r;
reg [63:0] x26_r;
reg [63:0] x27_r;
reg [63:0] x28_r;
reg [63:0] x29_r;
reg [63:0] x30_r;
reg [63:0] x31_r;

//-----------------------------------------------------------------------------
// Register Write
//-----------------------------------------------------------------------------
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset all registers with its defalut value
        x1_r    <= 64'h0000000000000000;
        x2_r    <= 64'h0000000000000000;
        x3_r    <= 64'h0000000000000000;
        x4_r    <= 64'h0000000000000000;
        x5_r    <= 64'h0000000000000000;
        x6_r    <= 64'h0000000000000000;
        x7_r    <= 64'h0000000000000000;
        x8_r    <= 64'h0000000000000000;
        x9_r    <= 64'h0000000000000000;
        x10_r   <= 64'h0000000000000000;
        x11_r   <= 64'h0000000000000000;
        x12_r   <= 64'h0000000000000000;
        x13_r   <= 64'h0000000000000000;
        x14_r   <= 64'h0000000000000000;
        x15_r   <= 64'h0000000000000000;
        x16_r   <= 64'h0000000000000000;
        x17_r   <= 64'h0000000000000000;
        x18_r   <= 64'h0000000000000000;
        x19_r   <= 64'h0000000000000000;
        x20_r   <= 64'h0000000000000000;
        x21_r   <= 64'h0000000000000000;
        x22_r   <= 64'h0000000000000000;
        x23_r   <= 64'h0000000000000000;
        x24_r   <= 64'h0000000000000000;
        x25_r   <= 64'h0000000000000000;
        x26_r   <= 64'h0000000000000000;
        x27_r   <= 64'h0000000000000000;
        x28_r   <= 64'h0000000000000000;
        x29_r   <= 64'h0000000000000000;
        x30_r   <= 64'h0000000000000000;
        x31_r   <= 64'h0000000000000000;
    end 
    else begin
        if (we_i) begin
            // Write data to rd register
            // Write to x0 is always ignored
            case (write_register_i)
                5'd1  : x1_r <= write_data_i;
                5'd2  : x2_r <= write_data_i;
                5'd3  : x3_r <= write_data_i;
                5'd4  : x4_r <= write_data_i;
                5'd5  : x5_r <= write_data_i;
                5'd6  : x6_r <= write_data_i;
                5'd7  : x7_r <= write_data_i;
                5'd8  : x8_r <= write_data_i;
                5'd9  : x9_r <= write_data_i;
                5'd10 : x10_r <= write_data_i;
                5'd11 : x11_r <= write_data_i;
                5'd12 : x12_r <= write_data_i;
                5'd13 : x13_r <= write_data_i;
                5'd14 : x14_r <= write_data_i;
                5'd15 : x15_r <= write_data_i;
                5'd16 : x16_r <= write_data_i;
                5'd17 : x17_r <= write_data_i;
                5'd18 : x18_r <= write_data_i;
                5'd19 : x19_r <= write_data_i;
                5'd20 : x20_r <= write_data_i;
                5'd21 : x21_r <= write_data_i;
                5'd22 : x22_r <= write_data_i;
                5'd23 : x23_r <= write_data_i;
                5'd24 : x24_r <= write_data_i;
                5'd25 : x25_r <= write_data_i;
                5'd26 : x26_r <= write_data_i;
                5'd27 : x27_r <= write_data_i;
                5'd28 : x28_r <= write_data_i;
                5'd29 : x29_r <= write_data_i;
                5'd30 : x30_r <= write_data_i;
                5'd31 : x31_r <= write_data_i;
            endcase
        end
    end
end

//-----------------------------------------------------------------------------
// Asynchronous read
//-----------------------------------------------------------------------------

always @(*) begin
    case (read_register_1_i)
        5'd1  : read_data_1_o = x1_r;
        5'd2  : read_data_1_o = x2_r;
        5'd3  : read_data_1_o = x3_r;
        5'd4  : read_data_1_o = x4_r;
        5'd5  : read_data_1_o = x5_r;
        5'd6  : read_data_1_o = x6_r;
        5'd7  : read_data_1_o = x7_r;
        5'd8  : read_data_1_o = x8_r;
        5'd9  : read_data_1_o = x9_r;
        5'd10 : read_data_1_o = x10_r;
        5'd11 : read_data_1_o = x11_r;
        5'd12 : read_data_1_o = x12_r;
        5'd13 : read_data_1_o = x13_r;
        5'd14 : read_data_1_o = x14_r;
        5'd15 : read_data_1_o = x15_r;
        5'd16 : read_data_1_o = x16_r;
        5'd17 : read_data_1_o = x17_r;
        5'd18 : read_data_1_o = x18_r;
        5'd19 : read_data_1_o = x19_r;
        5'd20 : read_data_1_o = x20_r;
        5'd21 : read_data_1_o = x21_r;
        5'd22 : read_data_1_o = x22_r;
        5'd23 : read_data_1_o = x23_r;
        5'd24 : read_data_1_o = x24_r;
        5'd25 : read_data_1_o = x25_r;
        5'd26 : read_data_1_o = x26_r;
        5'd27 : read_data_1_o = x27_r;
        5'd28 : read_data_1_o = x28_r;
        5'd29 : read_data_1_o = x29_r;
        5'd30 : read_data_1_o = x30_r;
        5'd31 : read_data_1_o = x31_r;
        default: begin
            // Treat x0 as always 0
            read_data_1_o = 64'h0;
        end
    endcase

    case (read_register_2_i)
        5'd1: read_data_2_o = x1_r;
        5'd2: read_data_2_o = x2_r;
        5'd3: read_data_2_o = x3_r;
        5'd4: read_data_2_o = x4_r;
        5'd5: read_data_2_o = x5_r;
        5'd6: read_data_2_o = x6_r;
        5'd7: read_data_2_o = x7_r;
        5'd8: read_data_2_o = x8_r;
        5'd9: read_data_2_o = x9_r;
        5'd10: read_data_2_o = x10_r;
        5'd11: read_data_2_o = x11_r;
        5'd12: read_data_2_o = x12_r;
        5'd13: read_data_2_o = x13_r;
        5'd14: read_data_2_o = x14_r;
        5'd15: read_data_2_o = x15_r;
        5'd16: read_data_2_o = x16_r;
        5'd17: read_data_2_o = x17_r;
        5'd18: read_data_2_o = x18_r;
        5'd19: read_data_2_o = x19_r;
        5'd20: read_data_2_o = x20_r;
        5'd21: read_data_2_o = x21_r;
        5'd22: read_data_2_o = x22_r;
        5'd23: read_data_2_o = x23_r;
        5'd24: read_data_2_o = x24_r;
        5'd25: read_data_2_o = x25_r;
        5'd26: read_data_2_o = x26_r;
        5'd27: read_data_2_o = x27_r;
        5'd28: read_data_2_o = x28_r;
        5'd29: read_data_2_o = x29_r;
        5'd30: read_data_2_o = x30_r;
        5'd31: read_data_2_o = x31_r;
        default: begin
            // Treat x0 as always 0
            read_data_2_o = 64'h0;
        end
    endcase
end

endmodule
