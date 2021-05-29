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

reg [31: 0] inst_file[31: 0];

always @(addr) begin
    inst = inst_file[addr];
end

// initial begin: instInit
//     integer i;
//     for (i = 0 ; i < 32 ; i = i + 1)
//         inst_file[i] = 0;
//     inst = 0;
// end

endmodule
