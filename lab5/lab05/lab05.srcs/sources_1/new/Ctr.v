`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 13:22:03
// Design Name:
// Module Name: Ctr
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


module Ctr(
           input [5: 0] op_code,
           output reg reg_dst,
           output reg alu_src,
           output reg mem2reg,
           output reg reg_write,
           output reg mem_read,
           output reg mem_write,
           output reg branch,
           output reg [1: 0] alu_op,
           output reg jump
       );

always @(op_code) begin
    // $stop;
    case (op_code)
        6'b000000: begin    // R type
            reg_dst = 1;
            alu_src = 0;
            mem2reg = 0;
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            branch = 0;
            alu_op = 2'b10;
            jump = 0;
        end
        6'b100011: begin    // lw
            reg_dst = 0;
            alu_src = 1;
            mem2reg = 1;
            reg_write = 1;
            mem_read = 1;
            mem_write = 0;
            branch = 0;
            alu_op = 2'b00;
            jump = 0;
        end
        6'b101011: begin    // sw
            reg_dst = 1'bx;
            alu_src = 1;
            mem2reg = 1'bx;
            reg_write = 0;
            mem_read = 0;
            mem_write = 1;
            branch = 0;
            alu_op = 2'b00;
            jump = 0;
        end
        6'b000100: begin    // beq
            reg_dst = 1'bx;
            alu_src = 0;
            mem2reg = 1'bx;
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            branch = 1;
            alu_op = 2'b01;
            jump = 0;
        end
        6'b000010: begin    // j
            reg_dst = 0;
            alu_src = 0;
            mem2reg = 0;
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            branch = 0;
            alu_op = 2'b00;
            jump = 1;
        end
        default: begin
            $stop;
            reg_dst = 0;
            alu_src = 0;
            mem2reg = 0;
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            branch = 0;
            alu_op = 2'b00;
            jump = 0;
        end
    endcase
end

endmodule
