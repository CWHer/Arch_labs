`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 14:07:49
// Design Name:
// Module Name: ALU
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


module ALU(input [31: 0] input1,
           input [31: 0] input2,
           input [3: 0] alu_ctr,
           output reg zero,
           output reg [31: 0] alu_res
          );

always @({input1, input2, alu_ctr}) begin
    case (alu_ctr)
        4'b0000:
            alu_res = input1 & input2;  // and
        4'b0001:
            alu_res = input1 | input2;  // or
        4'b0010:
            alu_res = input1 + input2;  // add
        4'b0110:
            alu_res = input1 - input2;  // sub
        4'b0111:
            // set on less than
            alu_res = ($signed(input1) < $signed(input2));
        4'b1100:
            alu_res = ~(input1 | input2);   // nor
        default:
            alu_res = 0;
    endcase
    zero = (alu_res == 0);
end

endmodule
