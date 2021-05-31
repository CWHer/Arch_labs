`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/30 22:55:39
// Design Name:
// Module Name: EXE_MEM
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


module EXE_MEM(
           input reset,
           input clk,
           input RES_OUT_MUX,
           input REG_WRITE,
           input MEM_READ,
           input MEM_WRITE,
           input BRANCH_MUX,
           input JUMP_MUX,
           input PC_REG_MUX,
           input REG_PC_MUX,
           input [31: 0] JUMP_ADDR,
           input [4: 0] WRITE_REG_ADDR,
           input [31: 0] READ_REG_1,
           input [31: 0] READ_REG_2,
           input ZERO,
           input [31: 0] ALU_RESULT,
           input [31: 0] BRANCH_ADDR,
           input [31: 0] PC4,
           output reg RES_OUT_MUX_OUT,
           output reg REG_WRITE_OUT,
           output reg MEM_READ_OUT,
           output reg MEM_WRITE_OUT,
           output reg BRANCH_MUX_OUT,
           output reg JUMP_MUX_OUT,
           output reg PC_REG_MUX_OUT,
           output reg REG_PC_MUX_OUT,
           output reg [31: 0] JUMP_ADDR_OUT,
           output reg [4: 0] WRITE_REG_ADDR_OUT,
           output reg [31: 0] READ_REG_1_OUT,
           output reg [31: 0] READ_REG_2_OUT,
           output reg ZERO_OUT,
           output reg [31: 0] ALU_RESULT_OUT,
           output reg [31: 0] BRANCH_ADDR_OUT,
           output reg [31: 0] PC4_OUT
       );

always @(posedge clk) begin
    $stop;
    if (reset) begin
        RES_OUT_MUX_OUT = 0;
        REG_WRITE_OUT = 0;
        MEM_READ_OUT = 0;
        MEM_WRITE_OUT = 0;
        BRANCH_MUX_OUT = 0;
        JUMP_MUX_OUT = 0;
        PC_REG_MUX_OUT = 0;
        REG_PC_MUX_OUT = 0;
        JUMP_ADDR_OUT = 0;
        WRITE_REG_ADDR_OUT = 0;
        READ_REG_1_OUT = 0;
        READ_REG_2_OUT = 0;
        ZERO_OUT = 0;
        ALU_RESULT_OUT = 0;
        BRANCH_ADDR_OUT = 0;
        PC4_OUT = 0;
    end
    else begin
        RES_OUT_MUX_OUT = RES_OUT_MUX;
        REG_WRITE_OUT = REG_WRITE;
        MEM_READ_OUT = MEM_READ;
        MEM_WRITE_OUT = MEM_WRITE;
        BRANCH_MUX_OUT = BRANCH_MUX;
        JUMP_MUX_OUT = JUMP_MUX;
        PC_REG_MUX_OUT = PC_REG_MUX;
        REG_PC_MUX_OUT = REG_PC_MUX;
        JUMP_ADDR_OUT = JUMP_ADDR;
        WRITE_REG_ADDR_OUT = WRITE_REG_ADDR;
        READ_REG_1_OUT = READ_REG_1;
        READ_REG_2_OUT = READ_REG_2;
        ZERO_OUT = ZERO;
        ALU_RESULT_OUT = ALU_RESULT;
        BRANCH_ADDR_OUT = BRANCH_ADDR;
        PC4_OUT = PC4;
    end
end

endmodule
