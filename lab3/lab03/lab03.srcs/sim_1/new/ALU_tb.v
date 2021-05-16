`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 14:11:48
// Design Name:
// Module Name: ALU_tb
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


module ALU_tb(
       );

wire [31: 0] alu_res;
reg [31: 0] input1;
reg [31: 0] input2;
reg [3: 0] alu_ctr;
wire zero;

ALU u0(.input1(input1),
       .input2(input2),
       .alu_ctr(alu_ctr),
       .zero(zero),
       .alu_res(alu_res)
      );

initial begin
    input1 = 0;
    input2 = 0;
    alu_ctr = 0;
    #100;

    // test and
    input1 = 15;
    input2 = 10;
    alu_ctr = 4'b0000;
    #100;

    // test or
    input1 = 15;
    input2 = 10;
    alu_ctr = 4'b0001;
    #100;

    // test add
    input1 = 15;
    input2 = 10;
    alu_ctr = 4'b0010;
    #100;

    // test sub 1
    input1 = 15;
    input2 = 10;
    alu_ctr = 4'b0110;
    #100;

    // test sub 2
    input1 = 10;
    input2 = 15;
    alu_ctr = 4'b0110;
    #100;

    // test set on less than 1
    input1 = 15;
    input2 = 10;
    alu_ctr = 4'b0111;
    #100;

    // test set on less than 2
    input1 = 10;
    input2 = 15;
    alu_ctr = 4'b0111;
    #100;

    // test nor 1
    input1 = 1;
    input2 = 1;
    alu_ctr = 4'b1100;
    #100;

    // test nor 2
    input1 = 16;
    input2 = 1;
    alu_ctr = 4'b1100;
    #100;
end
endmodule
