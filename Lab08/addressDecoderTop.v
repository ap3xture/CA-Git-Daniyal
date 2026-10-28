module addressDecoderTop (
    input clk,
    input rst,
    input [31:0] address,
    input readEnable,
    input writeEnable,
    input [31:0] writeData,
    input [15:0] switches_in,
    output [31:0] readData,
    output [15:0] leds_out
);

    wire dm_write, dm_read, led_write, switch_read;
    wire [31:0] dm_read_data;
    wire [31:0] switch_read_data;

    // Instantiate Address Decoder
    AddressDecoder decoder (
        .address(address),
        .cpu_memWrite(writeEnable),
        .cpu_memRead(readEnable),
        .DataMemWrite(dm_write),
        .DataMemRead(dm_read),
        .LEDWrite(led_write),
        .SwitchReadEnable(switch_read)
    );

    // Instantiate Data Memory
    DataMemory dmem (
        .clk(clk),
        .rst(rst),
        .MemWrite(dm_write),
        .address(address),
        .write_data(writeData),
        .read_data(dm_read_data)
    );

    // Instantiate LED Module (reused from Lab 5 code structure)[cite: 4, 6]
    switches led_mod (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(led_write),
        .readEnable(1'b0),
        .memAddress(address[29:0]),
        .leds(leds_out)
    );

    // Instantiate Switch Module (reused from Lab 5 code structure)[cite: 4, 7]
    leds switch_mod (
        .clk(clk),
        .rst(rst),
        .btns(16'b0),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(switch_read),
        .memAddress(address[29:0]),
        .switches(switches_in),
        .readData(switch_read_data)
    );

    // Multiplex read data back to CPU based on selection
    // Data Memory is 00 or 01, Switches are 11
    assign readData = (address[9:8] == 2'b00 || address[9:8] == 2'b01) ? dm_read_data :
                      (address[9:8] == 2'b11) ? switch_read_data : 32'b0;

endmodule
