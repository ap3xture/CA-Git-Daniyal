module basys3_top (
    input clk,
    input rst,
    input [15:0] switches_in,
    output [15:0] leds_out
);

    // Internal signals to drive the addressDecoderTop without breaking I/O limits
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;
    wire [31:0] readData;
    wire [15:0] internal_leds;

    // Instantiate your existing memory system top module internally
    addressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches_in(switches_in),
        .readData(readData),
        .leds_out(internal_leds)
    );

    // Simple slow clock counter to pace the FSM states automatically on hardware
    reg [25:0] clk_div;
    always @(posedge clk or posedge rst) begin
        if (rst) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    wire slow_clk = clk_div[23]; // Changes state roughly every ~0.16 seconds

    // FSM State Encoding
    reg [2:0] state;
    parameter IDLE         = 3'b000,
              WRITE_DM     = 3'b001,
              READ_DM      = 3'b010,
              WRITE_LED    = 3'b011,
              READ_SWITCH  = 3'b100;

    // FSM Control Logic
    always @(posedge slow_clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            address <= 32'h00000000;
            writeEnable <= 0;
            readEnable <= 0;
            writeData <= 32'h00000000;
        end else begin
            case (state)
                IDLE: begin
                    writeEnable <= 0;
                    readEnable <= 0;
                    state <= WRITE_DM;
                end

                WRITE_DM: begin
                    // Write switch pattern into Data Memory address 4 (Selector 00)
                    address <= 32'h00000004;
                    writeData <= {16'h0000, switches_in}; // Use physical switches as data
                    writeEnable <= 1;
                    readEnable <= 0;
                    state <= READ_DM;
                end

                READ_DM: begin
                    // Read back from Data Memory address 4
                    writeEnable <= 0;
                    readEnable <= 1;
                    state <= WRITE_LED;
                end

                WRITE_LED: begin
                    // Write data to the LED address range 0x200 (Selector 10)
                    address <= 32'h00000200;
                    
                    // CHANGE THIS LINE: 
                    // Instead of sending the raw switches directly to the LEDs,
                    // send whatever was just read out of the Data Memory (`readData`)!
                    writeData <= readData; // was: {16'h0000, switches_in}
                    
                    writeEnable <= 1;
                    readEnable <= 0;
                    state <= READ_SWITCH;
                end

                READ_SWITCH: begin
                    // Read from the Switch address range 0x300 (Selector 11)
                    address <= 32'h00000300;
                    writeEnable <= 0;
                    readEnable <= 1;
                    state <= WRITE_DM; // Loop back
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Assign internal system LEDs out to the physical board LEDs
    assign leds_out = internal_leds;

endmodule
