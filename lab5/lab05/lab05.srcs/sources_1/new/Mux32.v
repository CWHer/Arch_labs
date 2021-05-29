`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/29 10:21:15
// Design Name:
// Module Name: Mux32
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


module Mux32(
           input [31: 0] input1,
           input [31: 0] input0,
           input ctr,
           output reg [31: 0] data_out
       );

always @(input1 or input0
             or ctr) begin
    data_out = ctr ? input1 : input0;
end

endmodule
