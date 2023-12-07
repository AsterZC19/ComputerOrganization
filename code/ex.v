`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 22:55:58
// Design Name: 
// Module Name: ex
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


module ex(
    input                rst_n,
    input [6:0]          aluop_i,
    input [2:0]          alusel_i,
    input [31:0]         reg1_i,
    input [31:0]         reg2_i,
    input [4:0]          wd_i,
    input                wreg_i,
    
    output reg [4:0]     wd_o,
    output reg           wreg_o,
    output reg [31:0]    wdata_o
    );

reg [31:0] result;

always @ (*) begin         // 通过译码阶段发送过来的信息确定具体的预算操作
    if(~rst_n)
        result <= 0;
    else begin
        case(aluop_i)
            7'b0010011: begin
                case(alusel_i)
                    3'b000: result <= reg1_i + reg2_i;  // 执行具体的运算
                    3'b001: result <= reg1_i << reg2_i;
                    3'b100: result <= reg1_i ^ reg2_i;
                    3'b110: result <= reg1_i | reg2_i;
                    3'b111: result <= reg1_i & reg2_i;
                    default: begin
                        result <= 0;
                    end
                endcase
            end
            7'b0110011: begin
                case(alusel_i)
                    3'b000: result <= reg1_i + reg2_i;
                    3'b001: result <= reg1_i << reg2_i;
                    3'b100: result <= reg1_i ^ reg2_i;
                    3'b110: result <= reg1_i | reg2_i;
                    3'b111: result <= reg1_i & reg2_i;
                endcase
            end
            default: begin
            end
        endcase
    end
end

always @ (*) begin           // 将运算结果发送到下一阶段
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case(aluop_i)
        7'b0010011: begin
            case(alusel_i)
                3'b000,3'b001,3'b100,3'b110,3'b111: wdata_o <= result;
                default: begin
                end
            endcase
        end
        7'b0110011: begin
            case(alusel_i)
                3'b000,3'b001,3'b100,3'b110,3'b111: wdata_o <= result;
                default: begin
                end
            endcase
        end
        default: begin
            wdata_o <= 0;
        end
    endcase
end
endmodule
