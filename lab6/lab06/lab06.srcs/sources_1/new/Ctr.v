`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/16 13:22:03
// Design Name:
// Module Name: Ctr
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


module Ctr(
           input [31: 0] inst,
           input [2: 0] stall,
           output reg reg_dst_mux,
           output reg reg_ra_mux,
           output reg alu_src_mux,
           output reg res_out_mux,
           output reg reg_write,
           output reg mem_read,
           output reg mem_write,
           output reg branch_mux,
           output reg jump_mux,
           output reg shamt_mux,
           output reg pc_reg_mux,
           output reg reg_pc_mux,
           output reg ext_type,
           output reg [3: 0] alu_ctr,
           output reg [2: 0] stall_out
       );

wire [5: 0] op_code, funct;
assign op_code = inst[31: 26];
assign funct = inst[5: 0];

always @(inst or stall) begin
    // debug
    // $stop;
    if (!stall) begin

        // clear
        reg_dst_mux = 0; // rt
        reg_ra_mux = 0; // write to $ra?
        alu_src_mux = 0; // reg
        res_out_mux = 0; // alu res
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        branch_mux = 0;
        jump_mux = 0;
        shamt_mux = 0; // imm
        pc_reg_mux = 0; // pc not to reg
        reg_pc_mux = 0; // reg not to pc
        ext_type = 0; // zero extend
        alu_ctr = 0;
        stall_out = 0;

        if (inst) begin
            case (op_code)
                // add, sub, and, or, slt, jr, sll, srl
                6'b000000: begin
                    case (funct)
                        // add
                        6'b100000: begin
                            reg_dst_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0010; // add
                        end
                        // sub
                        6'b100010: begin
                            reg_dst_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0110; // sub
                        end
                        // and
                        6'b100100: begin
                            reg_dst_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0000; // and
                        end
                        // or
                        6'b100101: begin
                            reg_dst_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0001; // or
                        end
                        // slt
                        6'b101010: begin
                            reg_dst_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0111; // slt
                        end
                        // jr
                        6'b001000: begin
                            reg_pc_mux = 1;
                        end
                        // sll
                        6'b000000: begin
                            // $stop;
                            reg_dst_mux = 1;
                            shamt_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0011; // <<
                        end
                        // srl
                        6'b000010: begin
                            // $stop;
                            reg_dst_mux = 1;
                            shamt_mux = 1;
                            reg_write = 1;
                            alu_ctr = 4'b0100; // >>
                        end
                        default:
                            $stop;
                    endcase
                end
                6'b100011: begin    // lw
                    alu_src_mux = 1;
                    res_out_mux = 1;
                    reg_write = 1;
                    mem_read = 1;
                    alu_ctr = 4'b0010; // add
                    stall_out = 2;
                end
                6'b101011: begin    // sw
                    alu_src_mux = 1;
                    mem_write = 1;
                    alu_ctr = 4'b0010; // add
                    stall_out = 2;
                end
                6'b000100: begin    // beq
                    branch_mux = 1;
                    alu_ctr = 4'b0110; // sub
                end
                6'b000010: begin    // j
                    jump_mux = 1;
                end
                6'b000011: begin    // jal
                    reg_ra_mux = 1; // write to $ra
                    reg_write = 1;
                    pc_reg_mux = 1;
                    jump_mux = 1;
                end
                6'b001000: begin    // addi
                    alu_src_mux = 1;
                    reg_write = 1;
                    alu_ctr = 4'b0010; // add
                end
                6'b001100: begin    // andi
                    alu_src_mux = 1;
                    reg_write = 1;
                    ext_type = 1;
                    alu_ctr = 4'b0000; // and
                end
                6'b001101: begin    // ori
                    alu_src_mux = 1;
                    reg_write = 1;
                    ext_type = 1;
                    alu_ctr = 4'b0001; // or
                end
                default:
                    $stop;
            endcase
        end
        else
            $stop;
    end
end

endmodule
