`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 23:45:15
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
        input                clk,
        input                rst_n,
        
        input [4:0]          ex_wd,
        input                ex_wreg,
        input [31:0]         ex_wdata,
        input [31:0]         ex_mem_addr,
        input                ex_wmem,
        input                ex_rmem,
        
        output reg [4:0]     mem_wd,
        output reg           mem_wreg,
        output reg [31:0]    mem_wdata,
        output reg [31:0]    mem_addr_o
        output reg           wmem_o,
        output reg           rmem_o
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        mem_wd <= 0;
        mem_wreg <= 0;
        mem_wdata <= 0;
        mem_addr_o <= 0;
        wmem_o <= 0;
        rmem_o <= 0;
    end
    else begin
        mem_wd <= ex_wd;
        mem_wreg <= ex_wreg;
        mem_wdata <= ex_wdata;
        mem_addr_o <= ex_mem_addr;
        wmem_o <= ex_wmem;
        rmem_o <= ex_rmem;
    end
end
endmodule
