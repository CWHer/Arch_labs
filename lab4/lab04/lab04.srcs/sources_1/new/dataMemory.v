`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 15:10:31
// Design Name:
// Module Name: DataMemory
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


module DataMemory(
           input clk,
           input [31: 0] addr,
           input [31: 0] write_data,
           input mem_write,
           input mem_read,
           output reg [31: 0] read_data
       );

reg [31: 0] mem_file[63: 0];

// read
always @(addr or mem_read) begin
    if (mem_read)
        read_data = mem_file[addr];
end

// write
always @(negedge clk) begin
    if (mem_write)
        mem_file[addr] = write_data;
end

initial begin: dataInit
    integer i;
    for (i = 0 ; i < 64 ; i = i + 1)
        mem_file[i] = 0;
    read_data = 0;
end

endmodule
