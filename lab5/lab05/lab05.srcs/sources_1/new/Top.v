`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 21:16:38
// Design Name:
// Module Name: Top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Top(
           input clk,
           input reset
       );

reg [31: 0] PC;
wire [31: 0] inst;

// load instruction from mem
InstMemory inst_mem(.addr(PC), .inst(inst));

wire REG_DST, JUMP, BRANCH, MEM_READ;
wire MEM_TO_REG, MEM_WRITE, ALU_SRC, REG_WRITE;
wire [1: 0] ALU_OP;

// main controller
Ctr controller(.op_code(inst[31: 26]),
               .reg_dst(REG_DST),
               .alu_src(ALU_SRC),
               .mem2reg(MEM_TO_REG),
               .reg_write(REG_WRITE),
               .mem_read(MEM_READ),
               .mem_write(MEM_WRITE),
               .branch(BRANCH),
               .alu_op(ALU_OP),
               .jump(JUMP));

wire [4: 0] WRITE_REG;
wire [31: 0] READ_REG_1, READ_REG_2, REG_WRITE_DATA;

// register mux5
Mux5 write_reg_mux(.ctr(REG_DST),
                   .input1(inst[15: 11]),
                   .input0(inst[20: 16]),
                   .data_out(WRITE_REG));

// register file
Registers regs(.clk(clk),
               .reset(reset),
               .read_reg1(inst[25: 21]),
               .read_reg2(inst[20: 16]),
               .write_reg(WRITE_REG),
               .write_data(REG_WRITE_DATA),
               .reg_write(REG_WRITE),
               .read_data1(READ_REG_1),
               .read_data2(READ_REG_2));


wire [31: 0] IMM_SEXT, ALU_MUX_SRC, ALU_RESULT;
wire [3: 0] ALU_CTR_OUT;
wire ZERO;

// imm sign extend
Sext sext(.data_in(inst[15: 0]), .data_out(IMM_SEXT));
// alu control
ALUCtr alu_ctr(.funct(inst[5: 0]),
               .alu_op(ALU_OP),
               .aluctr_out(ALU_CTR_OUT));
// alu mux32
Mux32 alu_src_mux(.ctr(ALU_SRC),
                  .input1(IMM_SEXT),
                  .input0(READ_REG_2),
                  .data_out(ALU_MUX_SRC));
// ALU
ALU alu(.input1(READ_REG_1),
        .input2(ALU_MUX_SRC),
        .alu_ctr(ALU_CTR_OUT),
        .zero(ZERO),
        .alu_res(ALU_RESULT));

// data memory
wire [31: 0] MEM_READ_DATA;
DataMemory data_mem(.clk(clk),
                    .addr(ALU_RESULT),
                    .write_data(READ_REG_2),
                    .mem_write(MEM_WRITE),
                    .mem_read(MEM_READ),
                    .read_data(MEM_READ_DATA));
// register mux32
Mux32 reg_write_mux(.ctr(MEM_TO_REG),
                    .input1(MEM_READ_DATA),
                    .input0(ALU_RESULT),
                    .data_out(REG_WRITE_DATA));

// PC control
wire [31: 0] PC4;
wire [31: 0] BRANCH_ADDR, BRANCH_ADDR_OUT;
wire [31: 0] JUMP_ADDR, NEXT_PC;
// pc + 4
assign PC4 = PC + 4;
// jump address
assign JUMP_ADDR = {PC4[31: 28], inst[25: 0] << 2};
// branch address
assign BRANCH_ADDR = PC4 + (IMM_SEXT << 2);
// branch mux
Mux32 branch_mux(.ctr(BRANCH & ZERO),
                 .input1(BRANCH_ADDR),
                 .input0(PC4),
                 .data_out(BRANCH_ADDR_OUT));
// jump mux
Mux32 jump_mux(.ctr(JUMP),
               .input1(JUMP_ADDR),
               .input0(BRANCH_ADDR_OUT),
               .data_out(NEXT_PC));

// update PC
always @ (posedge clk) begin
    // $stop;
    if (reset)
        PC = 0;
    else
        PC = NEXT_PC;
end

endmodule
