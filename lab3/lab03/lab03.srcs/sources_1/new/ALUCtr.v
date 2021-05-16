`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 13:36:31
// Design Name:
// Module Name: ALUCtr
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


module ALUCtr(
           input [5: 0] funct,
           input [1: 0] alu_op,
           output reg [3: 0] aluctr_out
       );


always @({funct, alu_op}) begin
    casex (alu_op)
        2'b00:
            aluctr_out = 4'b0010;       // memory
        2'bx1:
            aluctr_out = 4'b0110;       // branch
        2'b1x: begin                    // R type
            case (funct[3: 0])
                4'b0000:
                    aluctr_out = 4'b0010;
                4'b0010:
                    aluctr_out = 4'b0110;
                4'b0100:
                    aluctr_out = 4'b0000;
                4'b0101:
                    aluctr_out = 4'b0001;
                4'b1010:
                    aluctr_out = 4'b0111;
                default:
                    aluctr_out = 4'b0000;
            endcase
        end
    endcase
end


endmodule
