`timescale 1ns / 1ps

module ALU_32bit(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire Zero
);

    assign Zero = (Result == 32'b0);
    
    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;
            4'b0001: Result = A | B;
            4'b0010: Result = A + B;
            4'b0110: Result = A - B;
            4'b1100: Result = A ^ B;
            4'b0100: Result = A << B[4:0];
            4'b0101: Result = A >> B[4:0];
            default: Result = 32'h0;
        endcase
    end
endmodule



