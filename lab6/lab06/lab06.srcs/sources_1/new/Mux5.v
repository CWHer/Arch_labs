`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 21:37:40
// Design Name:
// Module Name: Mux5
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


module Mux5(
           input [4: 0] input1,
           input [4: 0] input0,
           input ctr,
           output reg [4: 0] data_out
       );

always @(input1 or input0
             or ctr) begin
    data_out = ctr ? input1 : input0;
end

endmodule
