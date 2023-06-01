`timescale 1ns / 1ps

/*
    Reduced RISC-V Verilog Model
    
    Supported Instruction
    - ADD / ADDI
    - SUB
    - AND / OR
    - LD / SD
    - BEQ / BNE / BGE / BLT
    - SLL / SLLI / SRL / SRLI
*/
module riscv_top(
    input clk, rstn
    ,output opcode_valid    // Whether opcode is valid
    ,output error_datamem_misaligned_access     
    ,output error_datamem_invalid_address       
    ,output error_instrmem_misaligned_access    
    ,output error_instrmem_invalid_address      
);

// ====================================
//  Wires
// ====================================

// Program counter related
wire [63:0] pc;             // Program counter signal
wire [63:0] pc_next;        // Next program counter signal
wire        pcsrc;          // Signal indicating whether to branch
wire        lt;             // less-than flag
wire        zero;           // zero flag

// Instruction memory related
wire [31:0] instruction;    // Current RISC-V Instruction

// Control signal
wire        ctrl_alusrc;    // Use immediate as the second input of the ALU(1), or use RS2 instead(0)
wire        ctrl_memtoreg;  // Data memory value to RD register(1), or ALU result to RD register(0)
wire        ctrl_regwrite;  // Whether to allow write access to the RD register
wire        ctrl_memread;   // Whether to allow read access to the data memory
wire        ctrl_memwrite;  // Whether to allow write access to the data memory
wire        ctrl_branch;    // Whether it is a branch instruction
wire [ 1:0] ctrl_aluop;     // Determines how the ALU works(00: ADD, 01: SUB, 10: Instruction Specific)    
wire        ctrl_hasfunct7; // Whether opcode has a funct7 field(e.g.,R-type opcode)

// Register file related
wire [63:0] regfile_write_data;     // Data to be written to the destination register(rd)
wire [63:0] regfile_read_data_1;    // Index of the 1st source register(rs1) to read
wire [63:0] regfile_read_data_2;    // Index of the 2nd source register(rs2) to read

// Immediate-generator related
wire [63:0] immgen_out;     // Immediate value of current instruction

// ALU related
wire [63:0] alu_b;          // 2nd input of ALU
wire [63:0] alu_result;     // ALU calculation result
wire [ 3:0] alu_control;    // ALU control signal

// Data memory related
wire [63:0] datamem_read_data;  // Data memory output

// ====================================
//  Module Connection
// ====================================
// Control Module
riscv_control CONTROL (
    .opcode_i       (instruction[6:0])

,   .alusrc_o       (ctrl_alusrc)
,   .memtoreg_o     (ctrl_memtoreg)
,   .regwrite_o     (ctrl_regwrite)
,   .memread_o      (ctrl_memread)
,   .memwrite_o     (ctrl_memwrite)
,   .branch_o       (ctrl_branch)
,   .aluop_o        (ctrl_aluop)

,   .hasfunct7_o    (ctrl_hasfunct7)
,   .opcode_valid_o (opcode_valid)
);

// Register Module
riscv_regfile REGFILE (
    .clk            (clk)
,   .rstn           (rstn)
,   .we_i           (ctrl_regwrite)

,   .write_register_i   (instruction[11:7]) 
,   .write_data_i       (regfile_write_data)   
,   .read_register_1_i  (instruction[19:15])
,   .read_register_2_i  (instruction[24:20])

,   .read_data_1_o  (regfile_read_data_1)
,   .read_data_2_o  (regfile_read_data_2)
);

// Immediate Generator Module
riscv_immgen IMMGEN (
    .instruction_i  (instruction)
,   .immediate_o    (immgen_out)
);

// ALUSrc MUX
// Implementing a MUX using conditional operator
assign alu_b = ctrl_alusrc ? immgen_out : regfile_read_data_2;

// ALU Control Module
riscv_aluctrl ALUCTRL (
    .aluop_i        (ctrl_aluop)
,   .funct7_i       (instruction[30])
,   .funct3_i       (instruction[14:12])
,   .hasfunct7_i    (ctrl_hasfunct7)
,   .alu_control_o  (alu_control)
);

// ALU Module
riscv_alu ALU (
    .alu_control_i  (alu_control)
,   .alu_a_i        (regfile_read_data_1)
,   .alu_b_i        (alu_b)

,   .alu_result_o   (alu_result)
,   .zero_o         (zero)
,   .lt_o           (lt)
);

// Data memory
riscv_datamem DATAMEM (
    .clk                        (clk)
,   .address_i                  (alu_result)
,   .re_i                       (ctrl_memread)
,   .we_i                       (ctrl_memwrite)
,   .write_data_i               (regfile_read_data_2)
,   .read_data_o                (datamem_read_data)
,   .error_misaligned_o         (error_datamem_misaligned_access)
,   .error_invalid_address_o    (error_datamem_invalid_address)
);

// MemtoReg MUX
assign regfile_write_data = (ctrl_memtoreg) ? datamem_read_data : alu_result;

// Instruction memory
riscv_instrmem INSTRMEM (
    .address_i                  (pc)
,   .instruction_o              (instruction)
,   .error_misaligned_o         (error_instrmem_misaligned_access)
,   .error_invalid_address_o    (error_instrmem_invalid_address)
);

// Branch Module
riscv_branch BRANCH (
    .ctrl_branch_i  (ctrl_branch)
,   .funct3_i       (instruction[14:12])
,   .zero_i         (zero)
,   .lt_i           (lt)

,   .pcsrc_o       (pcsrc)
);

// Program Counter feedback Module
assign pc_next =    (pcsrc) ? (pc+immgen_out*2) : (pc+4);

// Program Counter Module
riscv_pc PCLOGIC(
    .clk            (clk)
,   .rstn           (rstn)
,   .pc_next_i      (pc_next)
,   .pc_o           (pc)
);

endmodule
