`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 02:06:47
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input              clk,     // clock
    input              rst_n,   // reset
    input [31:0]       pc_inc,  // pc increment
    input              pc_if_inc,  // if increment
    output reg [31:0]  pc,      // program counter
    output reg         ce       // clock enable
    );


// posedge: positive edge, negedge: negative edge
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n)
        ce <= 1'b0;     // reset is active, ce is 0, pc is 0
    else
        ce <= 1'b1;     // reset is inactive, ce is 1, pc is incremented by 4
end


always @ (posedge clk) begin
    if(~ce)
        pc <= 32'b0;
    else
        begin
            pc <= pc + 3'b100;  // pc is incremented by 4
            if(pc_if_inc)
                begin
                    pc <= pc - 3'b100;
                    pc <= pc + pc_inc;
                end
        end

end
endmodule
