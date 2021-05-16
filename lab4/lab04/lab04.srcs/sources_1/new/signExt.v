`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 15:33:19
// Design Name:
// Module Name: Sext
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


module Sext(
           input [15: 0] data_in,
           output [31: 0] data_out
       );

assign data_out = data_in[15] ?
       {16'hffff, data_in} : {16'h0000, data_in};


endmodule
