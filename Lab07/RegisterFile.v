`timescale 1ns / 1ps


module RegisterFile(
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] WriteData,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);


    // Array of 32 registers, each 32 bits wide
    reg [31:0] regs [31:0];
    integer i;


    // Combinational reads. Register x0 is hardwired to 0.
    assign ReadData1 = (rs1 == 5'b00000) ? 32'b0 : regs[rs1];
    assign ReadData2 = (rs2 == 5'b00000) ? 32'b0 : regs[rs2];


    // Synchronous writes and asynchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (WriteEnable && rd != 5'b00000) begin
            // Write only executes if WriteEnable is high and destination is not x0
            regs[rd] <= WriteData;
        end
    end
endmodule
