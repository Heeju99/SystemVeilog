`define ADD     4'b0000 //{func7[5], func3}
`define SUB     4'b1000
`define SLL     4'b0001
`define SRL     4'b0101
`define SRA     4'b1101
`define SLT     4'b0010
`define SLTU    4'b0011
`define XOR     4'b0100
`define OR      4'b0110
`define AND     4'b0111

//additional
`define BEQ     4'bx000
`define BNE     4'bx001
`define BLT     4'bx100
`define BGE     4'bx101
`define BLTU    4'bx110
`define BGEU    4'bx111

`define OP_TYPE_R 7'b0110011
`define OP_TYPE_L 7'b0000011
`define OP_TYPE_I 7'b0010011
`define OP_TYPE_S 7'b0100011
`define OP_TYPE_B 7'b1100011