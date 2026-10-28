module top_control_verification (
    input wire clk,       // 100 MHz board clock
    input wire [15:0] sw, // 16 physical switches
    output reg [15:0] led // 16 physical LEDs
);

    // Map physical switches to instruction fields
    wire [6:0] opcode = sw[6:0];
    wire [2:0] funct3 = sw[9:7];
    
    // Construct the 7-bit funct7 field. 
    // sw[10] controls bit 5 (0100000) to toggle between ADD and SUB.
    wire [6:0] funct7 = {1'b0, sw[10], 5'b00000}; 

    // Internal wires for control signals
    wire [1:0] ALUOp;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [3:0] ALUControl_out;

    // Instantiate MainControl
    MainControl main_ctrl (
        .opcode(opcode),
        .ALUOp(ALUOp),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    // Instantiate ALUControl (Corrected port map)
    ALUControl alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7), // Now passing the 7-bit vector
        .ALUControl(ALUControl_out)
    );

    // Simple FSM for reading switches and updating LEDs
    parameter READ_STATE = 1'b0;
    parameter UPDATE_STATE = 1'b1;
    reg state = READ_STATE;

    always @(posedge clk) begin
        case (state)
            READ_STATE: begin
                // Delay cycle to allow combinational logic to settle
                state <= UPDATE_STATE;
            end
            UPDATE_STATE: begin
                // Map control signals to physical LEDs
                led[0] <= RegWrite;
                led[1] <= MemRead;
                led[2] <= MemWrite;
                led[3] <= ALUSrc;
                led[4] <= MemtoReg;
                led[5] <= Branch;
                led[7:6] <= ALUOp;
                led[11:8] <= ALUControl_out;
                led[15:12] <= 4'b0000; // Unused LEDs off
                
                state <= READ_STATE;
            end
        endcase
    end
endmodule
