`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/30 22:55:39
// Design Name:
// Module Name: MEM_WB
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


module MEM_WB(
           input reset,
           input clk,
           input [31: 0] PC4,
           input [31: 0] MEM_READ_DATA,
           input [31: 0] ALU_RESULT,
           input RES_OUT_MUX,
           input PC_REG_MUX,
           input REG_WRITE,
           input [4: 0] WRITE_REG_ADDR,
           output reg [31: 0] PC4_OUT,
           output reg [31: 0] MEM_READ_DATA_OUT,
           output reg [31: 0] ALU_RESULT_OUT,
           output reg RES_OUT_MUX_OUT,
           output reg PC_REG_MUX_OUT,
           output reg REG_WRITE_OUT,
           output reg [4: 0] WRITE_REG_ADDR_OUT
       );

always @(posedge clk) begin
    $stop;
    if (reset) begin
        PC4_OUT = 0;
        MEM_READ_DATA_OUT = 0;
        ALU_RESULT_OUT = 0;
        RES_OUT_MUX_OUT = 0;
        PC_REG_MUX_OUT = 0;
        REG_WRITE_OUT = 0;
        WRITE_REG_ADDR_OUT = 0;
    end
    else begin
        PC4_OUT = PC4;
        MEM_READ_DATA_OUT = MEM_READ_DATA;
        ALU_RESULT_OUT = ALU_RESULT;
        RES_OUT_MUX_OUT = RES_OUT_MUX;
        PC_REG_MUX_OUT = PC_REG_MUX;
        REG_WRITE_OUT = REG_WRITE;
        WRITE_REG_ADDR_OUT = WRITE_REG_ADDR;
    end
end

endmodule
