`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 15:15:36
// Design Name:
// Module Name: dataMemory_tb
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


module dataMemory_tb(
       );

reg clock;
parameter PERIOD = 100;

always #(PERIOD) begin
    clock = !clock;
end

reg mem_write;
reg mem_read;
reg [31: 0] write_data;
reg [31: 0] addr;
wire [31: 0] read_data;

DataMemory Mem(.clk(clock),
               .addr(addr),
               .write_data(write_data),
               .mem_write(mem_write),
               .mem_read(mem_read),
               .read_data(read_data)
              );

initial begin
    clock = 0;
    mem_write = 0;
    mem_read = 0;
    write_data = 0;
    addr = 0;

    #185;   // 185ns
    mem_write = 1;
    addr = 7;
    write_data = 32'he0000000;

    #100;   // 285ns
    mem_write = 1;
    write_data = 32'hffffffff;
    addr = 6;

    #185;   // 470ns
    addr = 7;
    mem_read = 1;
    mem_write = 0;

    #80;    // 550ns
    mem_write = 1;
    addr = 8;
    write_data = 32'haaaaaaaa;

    #80;    // 630ns
    mem_write = 0;
    mem_read = 1;
    addr = 6;

end

endmodule
