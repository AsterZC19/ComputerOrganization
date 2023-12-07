`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 02:25:05
// Design Name: 
// Module Name: regfile
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


module regfile(
    input              rst_n,
    input              clk,
    // 写入端口
    input [4:0]        waddr,
    input [31:0]       wdata,
    input              we,
    
    // 读取端口1
    input [4:0]        raddr1,
    input              re1,
    output reg [31:0]  rdata1,
    
    // 读取端口2
    input [4:0]        raddr2,
    input              re2,
    output reg [31:0]  rdata2
    );
    
reg [31:0] mem_r [0:31];

// 写入寄存器
always @ (posedge clk or negedge rst_n) begin
    if(rst_n) begin
        if((waddr != 5'b0) && (we))
            mem_r[waddr] <= wdata;
    end
end

// 从端口 1 读取数据
always @ (*) begin                
    if(~rst_n)
        rdata1 <= 32'b0;
    else if(raddr1 == 5'b0)
        rdata1 <= 32'b0;
    else if((raddr1 == waddr) && re1 && we)        // 如果写入的地址与要读出的地址相同
        rdata1 <= wdata;                           // 则直接将写入的数据传给读出端口
    else if(re1)
        rdata1 <= mem_r[raddr1];
    else
        rdata1 <= 32'b0;
end

// 从端口 2 读取数据
always @ (*) begin
    if(~rst_n)
        rdata2 <= 32'b0;
    else if(raddr2 == 5'b0)
        rdata2 <= 32'b0;
    else if((raddr2 == waddr) && re2 && we)
        rdata2 <= wdata;
    else if(re2)
        rdata2 <= mem_r[raddr2];
    else
        rdata2 <= 32'b0;
end

endmodule
