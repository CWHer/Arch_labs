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
wire [31: 0] INST;

// finish when meeting nop
always @(INST) begin
    if (INST == 0)
        $finish;
end

// load instruction from mem
InstMemory inst_mem(.addr(PC), .inst(INST));

wire [3: 0] ALU_CTR;
wire REG_DST_MUX, ALU_SRC_MUX, RES_OUT_MUX;
wire REG_WRITE, MEM_RAED, MEM_WRITE, BRANCH_MUX;
wire JUMP_MUX, SHAMT_MUX, REG_RA_MUX;
wire PC_REG_MUX, REG_PC_MUX, EXT_TYPE;

// main controller
Ctr controller(
        .op_code(INST[31: 26]),
        .funct(INST[5: 0]),
        .reg_dst_mux(REG_DST_MUX),
        .reg_ra_mux(REG_RA_MUX),
        .alu_src_mux(ALU_SRC_MUX),
        .res_out_mux(RES_OUT_MUX),
        .reg_write(REG_WRITE),
        .mem_read(MEM_READ),
        .mem_write(MEM_WRITE),
        .branch_mux(BRANCH_MUX),
        .jump_mux(JUMP_MUX),
        .shamt_mux(SHAMT_MUX),
        .pc_reg_mux(PC_REG_MUX),
        .reg_pc_mux(REG_PC_MUX),
        .ext_type(EXT_TYPE),
        .alu_ctr(ALU_CTR));

wire [4: 0] INST_OUT, WRITE_REG_ADDR;
wire [31: 0] READ_REG_1, READ_REG_2, REG_WRITE_DATA;

// register dst
Mux5 write_reg_mux(
         .ctr(REG_DST_MUX),
         .input1(INST[15: 11]),
         .input0(INST[20: 16]),
         .data_out(INST_OUT));
// write to $ra? (newly added)
Mux5 reg_ra_mux(
         .ctr(REG_RA_MUX),
         .input1(5'b11111),
         .input0(INST_OUT),
         .data_out(WRITE_REG_ADDR));

// register file
Registers regs(
              .clk(clk),
              .reset(reset),
              .read_reg1(INST[25: 21]),
              .read_reg2(INST[20: 16]),
              .write_reg(WRITE_REG_ADDR),
              .write_data(REG_WRITE_DATA),
              .reg_write(REG_WRITE),
              .read_data1(READ_REG_1),
              .read_data2(READ_REG_2));


wire [31: 0] IMM_OUT, ALU_MUX_SRC1;
wire [31: 0] ALU_MUX_SRC2, ALU_RESULT;
wire ZERO;

// imm extend
Extend ext(
           .ext_type(EXT_TYPE),
           .data_in(INST[15: 0]),
           .data_out(IMM_OUT));
// alu mux32
Mux32 alu_src_mux(
          .ctr(ALU_SRC_MUX),
          .input1(IMM_OUT),
          .input0(READ_REG_2),
          .data_out(ALU_MUX_SRC2));
// shamt mux (0: reg_1, 1: shamt) (newly added)
Mux32 shamt_mux(
          .ctr(SHAMT_MUX),
          .input1({27'b0, INST[10: 6]}),
          .input0(READ_REG_1),
          .data_out(ALU_MUX_SRC1));
// ALU
ALU alu(
        .input1(ALU_MUX_SRC1),
        .input2(ALU_MUX_SRC2),
        .alu_ctr(ALU_CTR),
        .zero(ZERO),
        .alu_res(ALU_RESULT));

// data memory
wire [31: 0] MEM_READ_DATA;
DataMemory data_mem(
               .clk(clk),
               .addr(ALU_RESULT),
               .write_data(READ_REG_2),
               .mem_write(MEM_WRITE),
               .mem_read(MEM_READ),
               .read_data(MEM_READ_DATA));

wire [31: 0] RES_OUT;
wire [31: 0] PC4;
wire [31: 0] BRANCH_ADDR, BRANCH_OUT;
wire [31: 0] JUMP_ADDR, JUMP_OUT, NEXT_PC;
assign PC4 = PC + 4;
// jump address
assign JUMP_ADDR = {PC4[31: 28], INST[25: 0] << 2};
// branch address
assign BRANCH_ADDR = PC4 + (IMM_OUT << 2);
// result mux
Mux32 res_out_mux(
          .ctr(RES_OUT_MUX),
          .input1(MEM_READ_DATA),
          .input0(ALU_RESULT),
          .data_out(RES_OUT));
// pc to reg mux (jal) (newly added)
Mux32 reg_write_mux(
          .ctr(PC_REG_MUX),
          .input1(PC4),
          .input0(RES_OUT),
          .data_out(REG_WRITE_DATA));
// branch mux
Mux32 branch_mux(
          .ctr(BRANCH_MUX & ZERO),
          .input1(BRANCH_ADDR),
          .input0(PC4),
          .data_out(BRANCH_OUT));
// jump mux
Mux32 jump_mux(
          .ctr(JUMP_MUX),
          .input1(JUMP_ADDR),
          .input0(BRANCH_OUT),
          .data_out(JUMP_OUT));
// pc mux (jr) (newly added)
Mux32 pc_mux(
          .ctr(REG_PC_MUX),
          .input1(READ_REG_1),
          .input0(JUMP_OUT),
          .data_out(NEXT_PC));

// update PC
always @ (posedge clk) begin
    // debug
    // $stop;

    if (reset)
        PC = 0;
    else
        PC = NEXT_PC;
end

endmodule
