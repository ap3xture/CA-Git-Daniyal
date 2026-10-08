


`timescale 1ns / 1ps

module ALU_tb;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;

    wire [31:0] Result;
    wire Zero;

    ALU_32bit uut (
        .A(A), 
        .B(B), 
        .ALUControl(ALUControl), 
        .Result(Result), 
        .Zero(Zero)
    );

    initial begin
        // start everything at zero to clear any floating values
        A = 0;
        B = 0;
        ALUControl = 0;

        #10;
        
        // let's check the bitwise AND first
        A = 32'h00001430; B = 32'h00000015; ALUControl = 4'b0000; #10;
        
        // now verify the OR operation
        A = 32'h00001431; B = 32'h00000015; ALUControl = 4'b0001; #10;
        
        // making sure basic addition works
        A = 32'h00000010; B = 32'h00000008; ALUControl = 4'b0010; #10;
        
        // checking subtraction (hex 18 minus 8)
        A = 32'h00000018; B = 32'h00000008; ALUControl = 4'b0110; #10;
        
        // throwing in some values for XOR
        A = 32'h00000028; B = 32'h00000008; ALUControl = 4'b1100; #10;
        
        // shifting left by 1 position
        A = 32'h00000003; B = 32'h00000001; ALUControl = 4'b0100; #10;
        
        // shifting right by 1 position
        A = 32'h00000020; B = 32'h00000001; ALUControl = 4'b0101; #10;
        
        // finally, subtract identical numbers to make sure the zero flag actually trips
        A = 32'h00000010; B = 32'h00000010; ALUControl = 4'b0110; #10; 

        $finish;
    end

  
endmodule
