`timescale 1ns / 1ps

module top(
    input clk,
    input rst_btn,
    input [15:0] sw,
    output [6:0] seg,
    output [3:0] an,
    output [15:0] led
);
    wire rst;
    wire tick;
    wire [15:0] start_value;
    wire start_valid;
    wire [15:0] display_value;

    // LEDs ALWAYS mirror the live binary countdown value
    assign led = display_value;

    debouncer db_rst(
        .clk(clk),
        .pbin(rst_btn),
        .pbout(rst)
    );

    sw_debouncer sw_db(
        .clk(clk),
        .rst(rst),
        .sw_in(sw),
        .sw_stable(start_value),
        .start_valid(start_valid)
    );

    clock_divider cd(
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    fsm_counter fsm(
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .start_value(start_value),
        .start_valid(start_valid),
        .display_value(display_value)
    );

    sevenseg_decode ssd (
        .bin(display_value[3:0]),
        .seg(seg)
    );
    
    assign an = 4'b1110;

endmodule

// --- SUB-MODULES ---

// DEBOUNCES THE PHYSICAL SWITCHES
module sw_debouncer(
    input clk,
    input rst,
    input [15:0] sw_in,
    output reg [15:0] sw_stable = 0,
    output reg start_valid = 0
);
    reg [15:0] sw_sync_1 = 0, sw_sync_2 = 0;
    reg [19:0] count = 0;
    reg [15:0] prev_stable = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sw_sync_1 <= 16'b0;
            sw_sync_2 <= 16'b0;
        end else begin
            sw_sync_1 <= sw_in;
            sw_sync_2 <= sw_sync_1;
        end
    end

    // Wait 10ms for switches to stop bouncing (Real hardware value)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sw_stable <= 16'b0;
            count <= 0;
        end else begin
            if (sw_sync_2 != sw_stable) begin
                count <= count + 1;
                if (count == 20'd1_000_000) begin 
                    sw_stable <= sw_sync_2;
                    count <= 0;
                end
            end else begin
                count <= 0;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_stable <= 16'b0;
            start_valid <= 1'b0;
        end else begin
            prev_stable <= sw_stable;
            if (sw_stable != prev_stable) begin
                start_valid <= 1'b1;
            end else begin
                start_valid <= 1'b0;
            end
        end
    end
endmodule

// HANDLES THE COUNTDOWN LOGIC
module fsm_counter(
    input clk,
    input rst,
    input tick,
    input [15:0] start_value,
    input start_valid,
    output reg [15:0] display_value = 0 
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            display_value <= 16'b0;
        end else begin
            if (start_valid) begin
                display_value <= start_value;       
            end else if (tick && display_value > 0) begin
                display_value <= display_value - 1; 
            end
        end
    end
endmodule

// GENERATES 1 Hz TICK FROM 100MHz CLOCK
module clock_divider(
    input clk,
    input rst,
    output reg tick = 0 
);
    reg [26:0] count = 0; 
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            tick <= 0;
        end else begin
            // 1 Second for real hardware
            if (count == 27'd99_999_999) begin 
                count <= 0;
                tick <= 1;
            end else begin
                count <= count + 1;
                tick <= 0;
            end
        end
    end
endmodule

// DEBOUNCES THE RESET BUTTON
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

// DECODES BINARY TO 7-SEGMENT DISPLAY
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
