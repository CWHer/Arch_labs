`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/30 22:55:39
// Design Name:
// Module Name: ID_EXE
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


module ID_EXE(
           input reset,
           input clk,
           input [31: 0] PC4,
           input [3: 0] ALU_CTR,
           input ALU_SRC_MUX,
           input SHAMT_MUX,
           input RES_OUT_MUX,
           input REG_WRITE,
           input MEM_READ,
           input MEM_WRITE,
           input BRANCH_MUX,
           input JUMP_MUX,
           input PC_REG_MUX,
           input REG_PC_MUX,
           input [31: 0] JUMP_ADDR,
           input [31: 0] IMM_OUT,
           input [4: 0] SHAMT,
           input [4: 0] WRITE_REG_ADDR,
           input [31: 0] READ_REG_1,
           input [31: 0] READ_REG_2,
           output reg [31: 0] PC4_OUT,
           output reg [3: 0] ALU_CTR_OUT,
           output reg ALU_SRC_MUX_OUT,
           output reg SHAMT_MUX_OUT,
           output reg RES_OUT_MUX_OUT,
           output reg REG_WRITE_OUT,
           output reg MEM_READ_OUT,
           output reg MEM_WRITE_OUT,
           output reg BRANCH_MUX_OUT,
           output reg JUMP_MUX_OUT,
           output reg PC_REG_MUX_OUT,
           output reg REG_PC_MUX_OUT,
           output reg [31: 0] JUMP_ADDR_OUT,
           output reg [31: 0] IMM_OUT_OUT,
           output reg [4: 0] SHAMT_OUT,
           output reg [4: 0] WRITE_REG_ADDR_OUT,
           output reg [31: 0] READ_REG_1_OUT,
           output reg [31: 0] READ_REG_2_OUT
       );

always @(posedge clk) begin
    $stop;
    if (reset) begin
        PC4_OUT = 0;
        ALU_CTR_OUT = 0;
        ALU_SRC_MUX_OUT = 0;
        SHAMT_MUX_OUT = 0;
        RES_OUT_MUX_OUT = 0;
        REG_WRITE_OUT = 0;
        MEM_READ_OUT = 0;
        MEM_WRITE_OUT = 0;
        BRANCH_MUX_OUT = 0;
        JUMP_MUX_OUT = 0;
        PC_REG_MUX_OUT = 0;
        REG_PC_MUX_OUT = 0;
        JUMP_ADDR_OUT = 0;
        IMM_OUT_OUT = 0;
        SHAMT_OUT = 0;
        WRITE_REG_ADDR_OUT = 0;
        READ_REG_1_OUT = 0;
        READ_REG_2_OUT = 0;
    end
    else begin
        PC4_OUT = PC4;
        ALU_CTR_OUT = ALU_CTR;
        ALU_SRC_MUX_OUT = ALU_SRC_MUX;
        SHAMT_MUX_OUT = SHAMT_MUX;
        RES_OUT_MUX_OUT = RES_OUT_MUX;
        REG_WRITE_OUT = REG_WRITE;
        MEM_READ_OUT = MEM_READ;
        MEM_WRITE_OUT = MEM_WRITE;
        BRANCH_MUX_OUT = BRANCH_MUX;
        JUMP_MUX_OUT = JUMP_MUX;
        PC_REG_MUX_OUT = PC_REG_MUX;
        REG_PC_MUX_OUT = REG_PC_MUX;
        JUMP_ADDR_OUT = JUMP_ADDR;
        IMM_OUT_OUT = IMM_OUT;
        SHAMT_OUT = SHAMT;
        WRITE_REG_ADDR_OUT = WRITE_REG_ADDR;
        READ_REG_1_OUT = READ_REG_1;
        READ_REG_2_OUT = READ_REG_2;
    end
end

endmodule
