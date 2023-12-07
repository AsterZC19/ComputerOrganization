`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 02:16:20
// Design Name: 
// Module Name: if_id
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


module if_id(
    input              clk,
    input              rst_n,
    input [31:0]       if_pc,           // 取指阶段的 PC
    input [31:0]       if_inst,         // 取指阶段的指令
    output reg [31:0]  id_pc,           // 译码阶段的 PC
    output reg [31:0]  id_inst
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin                    // reset is active
        id_pc <= 32'b0;                 // 将取值阶段结果传给译码阶段
        id_inst <= 32'b0;
    end
    else begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end
endmodule
