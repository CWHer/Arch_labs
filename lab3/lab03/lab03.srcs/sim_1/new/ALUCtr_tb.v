`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 13:47:51
// Design Name:
// Module Name: ALUCtr_tb
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


module ALUCtr_tb(
       );

reg [5: 0] funct;
reg [1: 0] alu_op;

wire [3: 0] aluctr_out;

ALUCtr u1(.funct(funct),
          .alu_op(alu_op),
          .aluctr_out(aluctr_out)
         );

initial begin
    funct = 6'b000000;
    alu_op = 2'b00;
    // $stop;

    #100;
    alu_op = 2'b01;

    #100;
    alu_op = 2'b10;

    #50;
    funct = 6'b000010;
    #50;
    funct = 6'b000100;
    #50;
    funct = 6'b000101;
    #50;
    funct = 6'b001010;

end

endmodule
