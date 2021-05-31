`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/31 08:54:32
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


// stage in and out wire with prefix
// stage intermedia without prefix
module Top(
           input reset,
           input clk
       );

// ---------> IF begin
// solve control hazard
reg FLUSH;
reg [2: 0] STALL = 0;
// stall out from ID
wire [2: 0] STALL_OUT;

wire IF_BRANCH_MUX, IF_ZERO;
wire IF_REG_PC_MUX, IF_JUMP_MUX;
wire [31: 0] IF_JUMP_ADDR, IF_BRANCH_ADDR, IF_READ_REG_1;

reg [31: 0] PC;
wire [31: 0] IF_PC4, NEXT_PC, IF_INST;
wire [31: 0] BRANCH_OUT, JUMP_OUT;
assign IF_PC4 = PC + 4;

always @((IF_BRANCH_MUX & IF_ZERO)
             or IF_JUMP_MUX
             or IF_REG_PC_MUX) begin
    // may jump

    if ((IF_BRANCH_MUX & IF_ZERO)
            | IF_JUMP_MUX
            | IF_REG_PC_MUX) begin
        $stop;
        FLUSH <= 1;
        STALL <= 0;
    end
end

// branch mux
Mux32 branch_mux(
          .ctr(IF_BRANCH_MUX & IF_ZERO),
          .input1(IF_BRANCH_ADDR),
          .input0(IF_PC4),
          .data_out(BRANCH_OUT));
// jump mux
Mux32 jump_mux(
          .ctr(IF_JUMP_MUX),
          .input1(IF_JUMP_ADDR),
          .input0(BRANCH_OUT),
          .data_out(JUMP_OUT));
// pc mux (jr)
Mux32 pc_mux(
          .ctr(IF_REG_PC_MUX),
          .input1(IF_READ_REG_1),
          .input0(JUMP_OUT),
          .data_out(NEXT_PC));

// load instruction
InstMemory inst_mem(.addr(PC), .inst(IF_INST));

always @(posedge clk) begin
    // debug
    // $stop;
    FLUSH <= 0;
    if (STALL_OUT != 1'bx)
        STALL <= STALL_OUT;

    if (reset)
        PC <= 0;
    else begin
        if (STALL == 0)
            PC <= NEXT_PC;
        else
            STALL <= STALL - 1;
    end

end
// <--------- IF end
wire [31: 0] ID_PC4, ID_INST;
IF_ID if_id(
          .reset(reset | FLUSH),
          .stall(STALL),
          .clk(clk),
          .INST(IF_INST),
          .PC4(IF_PC4),

          .INST_OUT(ID_INST),
          .PC4_OUT(ID_PC4));

// ---------> ID begin
wire [3: 0] ID_ALU_CTR;
wire ID_ALU_SRC_MUX, ID_SHAMT_MUX;
wire ID_RES_OUT_MUX, ID_REG_WRITE;
wire ID_MEM_READ, ID_MEM_WRITE;
wire ID_BRANCH_MUX, ID_JUMP_MUX;
wire ID_PC_REG_MUX, ID_REG_PC_MUX;
wire [31: 0] ID_JUMP_ADDR, ID_IMM_OUT;
wire [4: 0] ID_WRITE_REG_ADDR;
wire [31: 0] ID_READ_REG_1, ID_READ_REG_2;
wire ID_REG_DST_MUX, ID_REG_RA_MUX, EXT_TYPE;

// instruction decode
Ctr controller(
        .inst(ID_INST),
        .stall(STALL),
        .reg_dst_mux(ID_REG_DST_MUX),
        .reg_ra_mux(ID_REG_RA_MUX),
        .alu_src_mux(ID_ALU_SRC_MUX),
        .res_out_mux(ID_RES_OUT_MUX),
        .reg_write(ID_REG_WRITE),
        .mem_read(ID_MEM_READ),
        .mem_write(ID_MEM_WRITE),
        .branch_mux(ID_BRANCH_MUX),
        .jump_mux(ID_JUMP_MUX),
        .shamt_mux(ID_SHAMT_MUX),
        .pc_reg_mux(ID_PC_REG_MUX),
        .reg_pc_mux(ID_REG_PC_MUX),
        .ext_type(EXT_TYPE),
        .alu_ctr(ID_ALU_CTR),
        .stall_out(STALL_OUT));

wire [4: 0] INST_OUT;
// register dst
Mux5 write_reg_mux(
         .ctr(ID_REG_DST_MUX),
         .input1(ID_INST[15: 11]),
         .input0(ID_INST[20: 16]),
         .data_out(INST_OUT));
// write to $ra? (newly added)
Mux5 reg_ra_mux(
         .ctr(ID_REG_RA_MUX),
         .input1(5'b11111),
         .input0(INST_OUT),
         .data_out(ID_WRITE_REG_ADDR));
// register file

// -----> WB begin
wire WB_REG_WRITE;
wire [4: 0] WB_WRITE_REG_ADDR;
wire [31: 0] WB_REG_WRITE_DATA;
// <----- WB end

Registers regs(
              .clk(clk),
              .reset(reset),
              .read_reg1(ID_INST[25: 21]),
              .read_reg2(ID_INST[20: 16]),
              .write_reg(WB_WRITE_REG_ADDR),
              .write_data(WB_REG_WRITE_DATA),
              .reg_write(WB_REG_WRITE),
              .read_data1(ID_READ_REG_1),
              .read_data2(ID_READ_REG_2));
// imm extend
Extend ext(
           .ext_type(EXT_TYPE),
           .data_in(ID_INST[15: 0]),
           .data_out(ID_IMM_OUT));
// jump address
assign ID_JUMP_ADDR = {ID_PC4[31: 28], ID_INST[25: 0] << 2};

// <--------- ID end
wire [31: 0] EXE_PC4;
wire [3: 0] EXE_ALU_CTR;
wire EXE_ALU_SRC_MUX;
wire EXE_SHAMT_MUX;
wire EXE_RES_OUT_MUX;
wire EXE_REG_WRITE;
wire EXE_MEM_READ;
wire EXE_MEM_WRITE;
wire EXE_BRANCH_MUX;
wire EXE_JUMP_MUX;
wire EXE_PC_REG_MUX;
wire EXE_REG_PC_MUX;
wire [31: 0] EXE_JUMP_ADDR;
wire [31: 0] EXE_IMM_OUT;
wire [4: 0] EXE_SHAMT;
wire [4: 0] EXE_WRITE_REG_ADDR;
wire [31: 0] EXE_READ_REG_1;
wire [31: 0] EXE_READ_REG_2;

ID_EXE id_exe(
           .reset(reset | FLUSH
                  | (STALL != 0)),
           .clk(clk),
           .PC4(ID_PC4),
           .ALU_CTR(ID_ALU_CTR),
           .ALU_SRC_MUX(ID_ALU_SRC_MUX),
           .SHAMT_MUX(ID_SHAMT_MUX),
           .RES_OUT_MUX(ID_RES_OUT_MUX),
           .REG_WRITE(ID_REG_WRITE),
           .MEM_READ(ID_MEM_READ),
           .MEM_WRITE(ID_MEM_WRITE),
           .BRANCH_MUX(ID_BRANCH_MUX),
           .JUMP_MUX(ID_JUMP_MUX),
           .PC_REG_MUX(ID_PC_REG_MUX),
           .REG_PC_MUX(ID_REG_PC_MUX),
           .JUMP_ADDR(ID_JUMP_ADDR),
           .IMM_OUT(ID_IMM_OUT),
           .SHAMT(ID_INST[10: 6]),
           .WRITE_REG_ADDR(ID_WRITE_REG_ADDR),
           .READ_REG_1(ID_READ_REG_1),
           .READ_REG_2(ID_READ_REG_2),

           .PC4_OUT(EXE_PC4),
           .ALU_CTR_OUT(EXE_ALU_CTR),
           .ALU_SRC_MUX_OUT(EXE_ALU_SRC_MUX),
           .SHAMT_MUX_OUT(EXE_SHAMT_MUX),
           .RES_OUT_MUX_OUT(EXE_RES_OUT_MUX),
           .REG_WRITE_OUT(EXE_REG_WRITE),
           .MEM_READ_OUT(EXE_MEM_READ),
           .MEM_WRITE_OUT(EXE_MEM_WRITE),
           .BRANCH_MUX_OUT(EXE_BRANCH_MUX),
           .JUMP_MUX_OUT(EXE_JUMP_MUX),
           .PC_REG_MUX_OUT(EXE_PC_REG_MUX),
           .REG_PC_MUX_OUT(EXE_REG_PC_MUX),
           .JUMP_ADDR_OUT(EXE_JUMP_ADDR),
           .IMM_OUT_OUT(EXE_IMM_OUT),
           .SHAMT_OUT(EXE_SHAMT),
           .WRITE_REG_ADDR_OUT(EXE_WRITE_REG_ADDR),
           .READ_REG_1_OUT(EXE_READ_REG_1),
           .READ_REG_2_OUT(EXE_READ_REG_2));

// <--------- EXE begin
wire [31: 0] ALU_MUX_SRC1, ALU_MUX_SRC2;
wire [31: 0] EXE_BRANCH_ADDR, EXE_ALU_RESULT;
wire EXE_ZERO;
// alu mux32
Mux32 alu_src_mux(
          .ctr(EXE_ALU_SRC_MUX),
          .input1(EXE_IMM_OUT),
          .input0(EXE_READ_REG_2),
          .data_out(ALU_MUX_SRC2));
// shamt mux (0: reg_1, 1: shamt) (newly added)
Mux32 shamt_mux(
          .ctr(EXE_SHAMT_MUX),
          .input1({27'b0, EXE_SHAMT}),
          .input0(EXE_READ_REG_1),
          .data_out(ALU_MUX_SRC1));
// ALU
ALU alu(
        .input1(ALU_MUX_SRC1),
        .input2(ALU_MUX_SRC2),
        .alu_ctr(EXE_ALU_CTR),
        .zero(EXE_ZERO),
        .alu_res(EXE_ALU_RESULT));

assign EXE_BRANCH_ADDR = EXE_PC4 + (EXE_IMM_OUT << 2);
// ---------> EXE end

wire MEM_RES_OUT_MUX, MEM_REG_WRITE;
wire MEM_MEM_READ, MEM_MEM_WRITE;
wire MEM_PC_REG_MUX;
wire [4: 0] MEM_WRITE_REG_ADDR;
wire [31: 0] MEM_READ_REG_2, MEM_ALU_RESULT;
wire [31: 0] MEM_PC4;

// also link to IF
EXE_MEM exe_mem(
            .reset(reset | FLUSH),
            .clk(clk),
            .RES_OUT_MUX(EXE_RES_OUT_MUX),
            .REG_WRITE(EXE_REG_WRITE),
            .MEM_READ(EXE_MEM_READ),
            .MEM_WRITE(EXE_MEM_WRITE),
            .BRANCH_MUX(EXE_BRANCH_MUX),
            .JUMP_MUX(EXE_JUMP_MUX),
            .PC_REG_MUX(EXE_PC_REG_MUX),
            .REG_PC_MUX(EXE_REG_PC_MUX),
            .JUMP_ADDR(EXE_JUMP_ADDR),
            .WRITE_REG_ADDR(EXE_WRITE_REG_ADDR),
            .READ_REG_1(EXE_READ_REG_1),
            .READ_REG_2(EXE_READ_REG_2),
            .ZERO(EXE_ZERO),
            .ALU_RESULT(EXE_ALU_RESULT),
            .BRANCH_ADDR(EXE_BRANCH_ADDR),
            .PC4(EXE_PC4),

            .RES_OUT_MUX_OUT(MEM_RES_OUT_MUX),
            .REG_WRITE_OUT(MEM_REG_WRITE),
            .MEM_READ_OUT(MEM_MEM_READ),
            .MEM_WRITE_OUT(MEM_MEM_WRITE),
            .BRANCH_MUX_OUT(IF_BRANCH_MUX),
            .JUMP_MUX_OUT(IF_JUMP_MUX),
            .PC_REG_MUX_OUT(MEM_PC_REG_MUX),
            .REG_PC_MUX_OUT(IF_REG_PC_MUX),
            .JUMP_ADDR_OUT(IF_JUMP_ADDR),
            .WRITE_REG_ADDR_OUT(MEM_WRITE_REG_ADDR),
            .READ_REG_1_OUT(IF_READ_REG_1),
            .READ_REG_2_OUT(MEM_READ_REG_2),
            .ZERO_OUT(IF_ZERO),
            .ALU_RESULT_OUT(MEM_ALU_RESULT),
            .BRANCH_ADDR_OUT(IF_BRANCH_ADDR),
            .PC4_OUT(MEM_PC4));

// ---------> MEM begin
wire [31: 0] MEM_MEM_READ_DATA;

DataMemory data_mem(
               .clk(clk),
               .addr(MEM_ALU_RESULT),
               .write_data(MEM_READ_REG_2),
               .mem_write(MEM_MEM_WRITE),
               .mem_read(MEM_MEM_READ),
               .read_data(MEM_MEM_READ_DATA));
// <--------- MEM end
wire [31: 0] WB_PC4;
wire [31: 0] WB_MEM_READ_DATA;
wire [31: 0] WB_ALU_RESULT;
wire WB_RES_OUT_MUX, WB_PC_REG_MUX;

MEM_WB mem_wb(
           .reset(reset),
           .clk(clk),
           .PC4(MEM_PC4),
           .MEM_READ_DATA(MEM_MEM_READ_DATA),
           .ALU_RESULT(MEM_ALU_RESULT),
           .RES_OUT_MUX(MEM_RES_OUT_MUX),
           .PC_REG_MUX(MEM_PC_REG_MUX),
           .REG_WRITE(MEM_REG_WRITE),
           .WRITE_REG_ADDR(MEM_WRITE_REG_ADDR),

           .PC4_OUT(WB_PC4),
           .MEM_READ_DATA_OUT(WB_MEM_READ_DATA),
           .ALU_RESULT_OUT(WB_ALU_RESULT),
           .RES_OUT_MUX_OUT(WB_RES_OUT_MUX),
           .PC_REG_MUX_OUT(WB_PC_REG_MUX),
           .REG_WRITE_OUT(WB_REG_WRITE),
           .WRITE_REG_ADDR_OUT(WB_WRITE_REG_ADDR)
       );

// ---------> WB begin

wire [31: 0] RES_OUT;
// result mux
Mux32 res_out_mux(.ctr(WB_RES_OUT_MUX),
                  .input1(WB_MEM_READ_DATA),
                  .input0(WB_ALU_RESULT),
                  .data_out(RES_OUT));
// pc to reg mux (jal)
Mux32 reg_write_mux(.ctr(WB_PC_REG_MUX),
                    .input1(WB_PC4),
                    .input0(RES_OUT),
                    .data_out(WB_REG_WRITE_DATA));
// <--------- WB end

endmodule
