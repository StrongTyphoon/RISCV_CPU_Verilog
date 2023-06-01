// ====================================
//  RISC-V Configuration
// ====================================
`define INSTRMEM_WIDTH  6               // Instruction Memory의 주소 폭. Instruction Memory 주소 단위가 4바이트(32bit)이므로 메모리 크기는 4*(2**INSTRMEM_WIDTH) byte
`define INSTRMEM_FILE   "instrmem.mem" // Instruction memory의 값을 불러오는 파일. 16진수 32비트 표현 문자열으로, 공백 또는 줄바꿈으로 구분됨.

`define DATAMEM_WIDTH   6               // Data Memory의 주소 폭. Data Memory 주소 단위가 8바이트(64bit)이므로 메모리 크기는 8*(2**INSTRMEM_WIDTH) byte
`define DATAMEM_FILE    "datamem.mem"   // Data memory의 값을 불러오는 파일. 16진수 64비트 표현 문자열으로, 공백 또는 줄바꿈으로 구분됨.


// ====================================
//  RISC-V Macro / Definitions
// ====================================
// ALU control code. 
// Refer to Fig 4.12
`define ALU_AND 4'b0000
`define ALU_OR  4'b0001
`define ALU_ADD 4'b0010
`define ALU_SUB 4'b0110
`define ALU_SLL 4'b1000
`define ALU_SRL 4'b1010

// RISC-V Opcodes
// Opcode의 Naming rule은 RISC-V base opcode map(Table 19.1) 따름
// https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf CH19(115P) 참고
// COD 책에서는 OP -> R-format, LOAD -> ld, STORE -> sd, BRANCH -> beq로 사용함
`define OP_OP       7'b0110011  // 64bit Register 사용 명령의 Opcode(DWORD R-Format)
`define OP_OP_IMM   7'b0010011  // 64bit Immediate 사용 명령의 Opcode(DWORD I-Format)
`define OP_LOAD     7'b0000011  // Load 명령의 Opcode(LD, ...)
`define OP_STORE    7'b0100011  // Store 명령의 Opcode(SD, ...)
`define OP_BRANCH   7'b1100011  // Branch 명령의 Opcode(BEQ, ...)
