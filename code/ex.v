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

    input [6:0]          aluc_i,
    input                wmem_i,
    input                rmem_i,
    input [31:0]         mem_addr_i,
    input [31:0]         ex_imm,
    input [5:0]          ex_rs1,
    input [5:0]          ex_rs2,

    output reg [31:0]    ex_inc,
    output reg           ex_if_inc,
    output reg           wmem_o,
    output reg           rmem_o,
    output reg [31:0]    mem_addr_o,
    
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
                    3'b000: result <= reg1_i + reg2_i;  // addi
                    3'b001: result <= reg1_i << reg2_i; // slli
                    3'b100: result <= reg1_i ^ reg2_i;  // xori
                    3'b110: result <= reg1_i | reg2_i;  // ori
                    3'b111: result <= reg1_i & reg2_i;  // andi
                    3'b101: begin
                        case(aluc_i)
                            7'b0000000: result <= reg1_i >> reg2_i; // srli
                            7'b0100000: result <= $signed(reg1_i) >>> reg2_i; // srai
                        endcase
                    end
                    3'b010: begin
                        if(reg1_i < reg2_i) result <= 1; // slti
                        else result <= 0;
                    end
                    3'b011: begin
                        if($unsigned(reg1_i) < $unsigned(reg2_i)) result <= 1; // sltiu
                        else result <= 0;
                    end
                    default: begin
                        result <= 0;
                    end
                endcase
            end
            7'b0110011: begin
                case(alusel_i)
                    3'b000: begin
                        case(aluc_i)
                            7'b0000000: result <= reg1_i + reg2_i; // add
                            7'b0100000: result <= $signed(reg1_i) - $signed(reg2_i); // sub
                        endcase
                    end
                    3'b001: result <= reg1_i << reg2_i; // sll
                    3'b100: result <= reg1_i ^ reg2_i;  // xor
                    3'b110: result <= reg1_i | reg2_i;  // or
                    3'b111: result <= reg1_i & reg2_i;  // and
                    3'b101: begin
                        case(aluc_i)
                            7'b0000000: result <= reg1_i >> reg2_i; // srl
                            7'b0100000: result <= $signed(reg1_i) >>> reg2_i; // sra
                        endcase
                    end
                    3'b010: begin
                        if(reg1_i < reg2_i) result <= 1; // slt
                        else result <= 0;
                    end
                    3'b011: begin
                        if($unsigned(reg1_i) < $unsigned(reg2_i)) result <= 1; // sltu
                        else result <= 0;
                    end
                endcase
            end
            7'b0000011: begin   // lb,lh,lw,lbu,lhu
                case(alusel_i)
                    3'b000: result <= {24'b0, mem_data_i[7:0]}; // lb
                    3'b001: result <= {16'b0, mem_data_i[15:0]}; // lh
                    3'b010: result <= mem_data_i; // lw
                    3'b100: result <= {24'b0, mem_data_i[7:0]}; // lbu
                    3'b101: result <= {16'b0, mem_data_i[15:0]}; // lhu
                endcase
            end
            7'b0100011: begin
                case(alusel_i)
                    3'b000: result <= reg2_i[7:0]; // sb
                    3'b001: result <= reg2_i[15:0]; // sh
                    3'b010: result <= reg2_i;          // sw
                endcase
            end
            7'b0110111: begin
                case(alusel_i)
                    3'b000: result <= reg1_i << 12; // lui
                endcase
            end
            7'b0010111: begin
                case(alusel_i)
                    3'b000: result <= reg1_i << 12; // auipc
                endcase
            end
            7'b1100011: begin
                case(alusel_i)
                    3'b000: begin
                        result <= 0;
                        if (ex_rs1 == ex_rs2)      // beq
                            begin
                                ex_inc <= ex_imm;
                                ex_if_inc <= 1;
                            end
                    end
                    3'b001: begin
                        result <= 0;
                        if (ex_rs1 != ex_rs2)      // bne
                            begin
                                ex_inc <= ex_imm;
                                ex_if_inc <= 1;
                            end
                    end
                    3'b110: begin
                        result <= 0;
                        if (ex_rs1 < ex_rs2)      // blt
                            begin
                                ex_inc <= ex_imm;
                                ex_if_inc <= 1;
                            end
                    end
                    3'b111: begin
                        result <= 0;
                        if (ex_rs1 >= ex_rs2)      // bge
                            begin
                                ex_inc <= ex_imm;
                                ex_if_inc <= 1;
                            end
                    end
            default: begin
            end
        endcase
    end
end

always @ (*) begin           // 将运算结果发送到下一阶段
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    wmem_o <= wmem_i;
    rmem_o <= rmem_i;
    mem_addr_o <= mem_addr_i;
    case(aluop_i)
        7'b0010011: begin
            case(alusel_i)      // I-type
                3'b000,3'b001,3'b100,3'b110,3'b111,3'b101,3'b010,3'b011: wdata_o <= result;
                default: begin
                end
            endcase
        end
        7'b0110011: begin
            case(alusel_i)      // R-type
                3'b000,3'b001,3'b100,3'b110,3'b111,3'b101,3'b010,3'b011: wdata_o <= result;
                default: begin
                end
            endcase
        end
        7'b0110111: begin       // lui
            wdata_o <= result;
        end
        7'b0010111: begin       // auipc
            wdata_o <= result + ex_inc;
        end
        7'b0000011: begin   // lb,lh,lw,lbu,lhu
            case(alusel_i)
                3'b000: begin // lb
                    wdata_o <= {24'b0, mem_data_i[7:0]};
                    mem_addr_o <= reg1_i + mem_addr_i;
                end
                3'b001: begin // lh
                    wdata_o <= {16'b0, mem_data_i[15:0]};
                    mem_addr_o <= reg1_i + mem_addr_i;
                end
                3'b010: begin // lw
                    wdata_o <= mem_data_i;
                    mem_addr_o <= reg1_i + mem_addr_i;
                end
                3'b100: begin // lbu
                    wdata_o <= {24'b0, mem_data_i[7:0]};
                    mem_addr_o <= reg1_i + mem_addr_i;
                end
                3'b101: begin // lhu
                    wdata_o <= {16'b0, mem_data_i[15:0]};
                    mem_addr_o <= reg1_i + mem_addr_i;
                end
            endcase
        end
        7'b1100011: begin
            case(alusel_i)
                3'b000: begin
                    result <= 0;
                    if (ex_rs1 == ex_rs2)      // beq
                        begin
                            ex_inc <= ex_imm;
                            ex_if_inc <= 1;
                        end
                end
                3'b001: begin
                    result <= 0;
                    if (ex_rs1 != ex_rs2)      // bne
                        begin
                            ex_inc <= ex_imm;
                            ex_if_inc <= 1;
                        end
                end
                3'b110: begin
                    result <= 0;
                    if (ex_rs1 < ex_rs2)      // blt
                        begin
                            ex_inc <= ex_imm;
                            ex_if_inc <= 1;
                        end
                end
                3'b111: begin
                    result <= 0;
                    if (ex_rs1 >= ex_rs2)      // bge
                        begin
                            ex_inc <= ex_imm;
                            ex_if_inc <= 1;
                        end
                end
            endcase
        end

        default: begin
            wdata_o <= 0;
        end
    endcase
end
endmodule
