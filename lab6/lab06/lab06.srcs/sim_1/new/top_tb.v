`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/31 14:19:36
// Design Name:
// Module Name: top_tb
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


module top_tb(
       );

reg clock, reset;

always #20 begin
    clock = !clock;
end

Top top(.clk(clock),
        .reset(reset));

initial begin
    $readmemh("C:/Users/cwher/Desktop/data.txt",
              top.data_mem.mem_file);
    $readmemh("C:/Users/cwher/Desktop/inst.txt",
              top.inst_mem.inst_file);
    reset = 1;
    clock = 0;
    #45;
    reset = 0;
end

endmodule
