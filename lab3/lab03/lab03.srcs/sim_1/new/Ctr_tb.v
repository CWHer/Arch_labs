`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 13:25:47
// Design Name:
// Module Name: Ctr_tb
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


module Ctr_tb(
       );

reg [5: 0] op_code;
wire reg_dst;
wire alu_src;
wire mem2reg;
wire reg_write;
wire mem_read;
wire mem_write;
wire branch;
wire [1: 0] alu_op;
wire jump;


Ctr u0(.op_code(op_code),
       .reg_dst(reg_dst),
       .alu_src(alu_src),
       .mem2reg(mem2reg),
       .reg_write(reg_write),
       .mem_read(mem_read),
       .mem_write(mem_write),
       .branch(branch),
       .alu_op(alu_op),
       .jump(jump)
      );

initial begin
    op_code = 0;

    #100;   // R type
    op_code = 6'b000000;

    #100;   // lw
    op_code = 6'b100011;

    #100;   // sw
    op_code = 6'b101011;

    #100;   // beq
    op_code = 6'b000100;

    #100;   // j
    op_code = 6'b000010;

    #100;
    op_code = 6'b010101;


end
endmodule
