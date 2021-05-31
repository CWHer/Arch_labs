`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 14:32:09
// Design Name:
// Module Name: Registers
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


module Registers(
           input clk,
           input reset,
           input [25: 21] read_reg1,
           input [20: 16] read_reg2,
           input [4: 0] write_reg,
           input [31: 0] write_data,
           input reg_write,
           output reg [31: 0] read_data1,
           output reg [31: 0] read_data2
       );
// 32 registers
reg [31: 0] reg_file[31: 0];
// solve structural hazard
// write first then read
reg write_finish;

// read
always @(read_reg1 or read_reg2
             or reg_write or write_finish) begin

    read_data1 = reg_file[read_reg1];
    read_data2 = reg_file[read_reg2];

end

// write
always @(negedge clk) begin
    if (reg_write) begin
        // $stop;
        reg_file[write_reg] = write_data;
        write_finish = !write_finish;
    end

end

always @(posedge reset) begin: regReset
    integer i;
    for (i = 0 ; i < 32 ; i = i + 1)
        reg_file[i] = 0;
    read_data1 = 0;
    read_data2 = 0;
    write_finish = 0;
end

endmodule
