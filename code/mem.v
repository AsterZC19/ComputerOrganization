`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 10:40:48
// Design Name: 
// Module Name: mem
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


module mem(
    input                 rst_n,
    
    input [4:0]           wd_i,
    input                 wreg_i,
    input [31:0]          wdata_i,
    input [31:0]          mem_addr_i,
    input                 wmem_i,
    input                 rmem_i,

    input [31:0]          mem_data_i,

    output reg [31:0]     mem_waddr_o,
    output reg [31:0]     mem_raddr_o,
    output reg [31:0]     mem_data_o,
    output reg            wmem_o,
    
    output reg [4:0]      wd_o,
    output reg            wreg_o,
    output reg [31:0]     wdata_o
    );
    
always @ (*) begin
    if(~rst_n) begin
        wd_o <= 0;
        wreg_o <= 0;
        wdata_o <= 0;
        mem_waddr_o <= 0;
        mem_raddr_o <= 0;
        mem_data_o <= 0;
        wmem_o <= 0;
    end
    else begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        wdata_o <= wdata_i;
        mem_waddr_o <= 0;
        mem_raddr_o <= 0;
        mem_data_o <= 0;
        wmem_o <= 0;
        if (rmem_i) begin
            mem_raddr_o <= mem_addr_i;
            wdata_o <= mem_data_i;
        end
        else if (wmem_i) begin
            mem_waddr_o <= mem_addr_i;
            mem_data_o <= wdata_i;
            wmem_o <= wmem_i;
        end
    end
end
endmodule
