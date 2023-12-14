`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 10:40:48
// Design Name: 
// Module Name: datamem
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


module datamem(
    input           rst_n,
    input           clk,
    
    input [31:0]    mwaddr,
    input [31:0]    wdata,
    input           mwe,
    
    input [31:0]    mraddr,
    input           mre,
    output reg [31:0]   mrdata
    );
    
reg [31:0] mem_r [0:1024];

always @(posedge clk or negedge rst_n) begin
    if (rst_n) begin
        if (mwaddr != 32'b0) && (mwe))
            mem_r[mwaddr] <= wdata;
    end
end

always @ (*) begin
    if (~rst_n)
        mrdata <= 32'b0;
    else if (mraddr == 32'b0)
        mrdata <=32'b0;
    else if ((mraddr == mwaddr) && mre &&mwe)
        mrdata <= wdata;
    else if (mre)
        mrdata <= mem_r[mraddr];
    else
        mrdata <= 32'b0;
end
    
endmodule
