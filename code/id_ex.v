`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 22:37:29
// Design Name: 
// Module Name: id_ex
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


module id_ex(
        input                clk,
        input                rst_n,
        
        input [6:0]          id_aluop,
        input [2:0]          id_alusel,
        input [31:0]         id_reg1,
        input [31:0]         id_reg2,
        input [4:0]          id_wd,
        input                id_wreg,               // 目的寄存器使能
        
        input [31:0]         id_imm,
        input [5:0]          id_rs1,
        input [5:0]          id_rs2,
        input [6:0]          id_aluop,
        input [2:0]          id_alusel,
        input [31:0]         id_reg1,
        input [31:0]         id_reg2,
        input [4:0]          id_wd,
        input                id_wreg,               // 目的寄存器使能
        input [6:0]          id_aluc,
        input                id_wmem,
        input                id_rmem,
        input [31:0]         id_mem_addr,


        output reg [6:0]     ex_aluop,
        output reg [2:0]     ex_alusel,
        output reg [31:0]    ex_reg1,
        output reg [31:0]    ex_reg2,
        output reg [4:0]     ex_wd,
        output reg           ex_wreg

        output reg [31:0]    ex_imm,
        output reg [5:0]     ex_rs1,
        output reg [5:0]     ex_rs2,
        output reg [6:0]     ex_aluop,
        output reg [2:0]     ex_alusel,
        output reg [31:0]    ex_reg1,
        output reg [31:0]    ex_reg2,
        output reg [4:0]     ex_wd,
        output reg           ex_wreg,
        output reg [6:0]     ex_aluc,
        output reg           ex_wmem,
        output reg           ex_rmem,
        output reg [31:0]    ex_mem_addr
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        ex_aluop <= 0;
        ex_alusel <= 0;
        ex_reg1 <= 0;
        ex_reg2 <= 0;
        ex_wd <= 0;
        ex_wreg <= 0;

        ex_imm <= 0;
        ex_aluc <= 0;
        ex_wmem <= 0;
        ex_rmem <= 0;
        ex_mem_addr <= 0;
    end
    else begin
        ex_aluop <= id_aluop;
        ex_alusel <= id_alusel;
        ex_reg1 <= id_reg1;
        ex_reg2 <= id_reg2;
        ex_wd <= id_wd;
        ex_wreg <= id_wreg;

        ex_imm <= id_imm;
        ex_aluc <= id_aluc;
        ex_wmem <= id_wmem;
        ex_rmem <= id_rmem;
        ex_mem_addr <= id_mem_addr;
        ex_rs1 <= id_rs1;
        ex_rs2 <= id_rs2; 
    end
end
endmodule
