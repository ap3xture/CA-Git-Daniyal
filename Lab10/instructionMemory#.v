module instructionMemory#(
    parameter OPERAND_LENGTH = 31
)(
    input [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);
    reg [7:0] memory [0:255];
    
    initial begin
        $readmemh("program.mem", memory);
    end

    // Little-endian byte assembly into 32-bit instruction
    always @(*) begin
        instruction = {
            memory[instAddress + 3],
            memory[instAddress + 2],
            memory[instAddress + 1],
            memory[instAddress + 0]
        };
    end
endmodule
