`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 21:06:28
// Design Name:
// Module Name: InstMemory
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


module InstMemory(
           input [31: 0] addr,
           output reg [31: 0] inst
       );

reg [31: 0] inst_file[63: 0];

always @(addr) begin
    inst = inst_file[addr >> 2];
end

endmodule
