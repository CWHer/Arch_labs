`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 15:37:35
// Design Name:
// Module Name: signext_tb
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


module signext_tb(
       );

reg [15: 0] data_in;
wire [31: 0] data_out;

Sext sext(
         .data_in(data_in),
         .data_out(data_out)
     );

initial begin
    data_in = 16'h0000;

    #200;
    data_in = 1;

    #200;
    data_in = 16'hffff;

    #200;
    data_in = 2;

    #200;
    data_in = 16'hfffe;
end

endmodule
