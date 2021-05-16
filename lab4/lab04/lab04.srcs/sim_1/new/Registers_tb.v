`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 14:42:51
// Design Name:
// Module Name: Registers_tb
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


module Registers_tb(
       );

reg clock;
parameter PERIOD = 100;


always #(PERIOD) begin
    clock = !clock;
end

reg reg_write;
reg [31: 0] write_data;
reg [4: 0] write_reg;
reg [25: 21] read_reg1;
reg [20: 16] read_reg2;
wire [31: 0] read_data1;
wire [31: 0] read_data2;

Registers Reg(.clk(clock),
              .read_reg1(read_reg1),
              .read_reg2(read_reg2),
              .write_reg(write_reg),
              .write_data(write_data),
              .reg_write(reg_write),
              .read_data1(read_data1),
              .read_data2(read_data2)
             );

initial begin
    // initial
    clock = 0;
    read_reg1 = 0;
    read_reg2 = 0;
    write_reg = 0;
    write_data = 0;
    reg_write = 0;
    #100;
    clock = 0;

    #185;   // 285ns
    reg_write = 1;
    write_reg = 5'b10101;
    write_data = 32'hffff0000;

    #200;   // 485ns
    write_reg = 5'b01010;
    write_data = 32'h0000ffff;

    #200;   // 685ns
    reg_write = 0;
    write_reg = 5'b00000;
    write_data = 0;

    #50;    // 735ns
    read_reg1 = 5'b10101;
    read_reg2 = 5'b01010;
end

endmodule
