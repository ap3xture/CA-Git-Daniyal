`timescale 1ns / 1ps

module top_rf_alu(
    input clk,
    input rst_btn,
    input [15:0] sw,
    output [6:0] seg,
    output [3:0] an,
    output [15:0] led
);

    // 1. Reset Debouncer
    wire rst;
    debouncer db_rst(
        .clk(clk),
        .pbin(rst_btn),
        .pbout(rst)
    );

    // 2. Map Switches
    wire [3:0] alu_op    = sw[3:0];
    wire [4:0] manual_rd = sw[8:4];
    wire       manual_we = sw[15];
    wire       view_mode = sw[14]; // Switch 14 toggles Lower vs Upper 16-bits

    // 3. FSM States for Startup Initialization
    localparam S_INIT1  = 2'd0;
    localparam S_INIT2  = 2'd1;
    localparam S_MANUAL = 2'd2;

    reg [1:0] state, next_state;

    // Register File Control Signals
    reg rf_we;
    reg [4:0] rf_rs1, rf_rs2, rf_rd;
    reg [31:0] rf_wd;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] alu_result;
    wire zero_flag;

    // FSM State Register
    always @(posedge clk) begin
        if (rst) state <= S_INIT1;
        else     state <= next_state;
    end

    // FSM Combinational Logic
    always @(*) begin
        next_state = state;
        rf_we  = 0;
        rf_rs1 = 5'd1; 
        rf_rs2 = 5'd2; 
        rf_rd  = 5'd0;
        rf_wd  = 32'd0;

        case (state)
            S_INIT1: begin
                rf_we = 1;
                rf_rd = 5'd1;             
                rf_wd = 32'h10101110;     
                next_state = S_INIT2;
            end
            
            S_INIT2: begin
                rf_we = 1;
                rf_rd = 5'd2;             
                rf_wd = 32'h01010101;     
                next_state = S_MANUAL;
            end
            
            S_MANUAL: begin
                rf_we = manual_we;
                rf_rd = manual_rd;
                rf_wd = alu_result;       
            end
        endcase
    end

    // 4. Instantiate Register File
    RegisterFile rf_inst (
        .clk(clk),
        .rst(rst),
        .WriteEnable(rf_we),
        .rs1(rf_rs1),
        .rs2(rf_rs2),
        .rd(rf_rd),
        .WriteData(rf_wd),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // 5. Instantiate ALU
    ALU_32bit alu_inst (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(alu_op),
        .Result(alu_result),
        .Zero(zero_flag)
    );

    // ==========================================
    // 6. FULL 32-BIT LED INSPECTOR (All 16 LEDs Used!)
    // ==========================================
    // If sw[14] is 0, show lower 16 bits. If sw[14] is 1, show upper 16 bits.
    assign led = view_mode ? alu_result[31:16] : alu_result[15:0];

    // 7. Map Result to Seven Segment Display
    sevenseg_decode ssd (
        .bin(alu_result[3:0]), 
        .seg(seg)
    );
    
    // Turn on only the right-most digit of the 7-segment display
    assign an = 4'b1110; 

endmodule


// --- REQUIRED SUB-MODULES ---

module debouncer(
    input clk,
    input pbin,
    output reg pbout = 0
);
    reg pb_sync_0 = 0, pb_sync_1 = 0;
    reg [19:0] count = 0;
    
    always @(posedge clk) begin
        pb_sync_0 <= pbin;
        pb_sync_1 <= pb_sync_0;
    end
    
    always @(posedge clk) begin
        if (pb_sync_1 == pbout) begin
            count <= 0;
        end else begin
            count <= count + 1;
            if (count == 20'd1_000_000) begin
                pbout <= pb_sync_1;
                count <= 0;
            end
        end
    end
endmodule

module sevenseg_decode(
    input wire [3:0] bin,
    output reg [6:0] seg
);
    always @(*) begin
        case (bin)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100011;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end
endmodule
