`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/30 22:55:39
// Design Name:
// Module Name: IF_ID
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


module IF_ID(
           input reset,
           input clk,
           input [2: 0] stall,
           input [31: 0] INST,
           input [31: 0] PC4,
           output reg [31: 0] INST_OUT,
           output reg [31: 0] PC4_OUT
       );


always @(posedge clk) begin
    // $stop;

    // do not change ID when stalled
    if (!stall) begin
        if (reset) begin
            PC4_OUT = 0;
            INST_OUT = 0;
        end
        else begin
            PC4_OUT = PC4;
            INST_OUT = INST;
        end
    end
end

endmodule
