`timescale 1ns / 1ps

module MemorySystem_tb;
    reg clk;
    reg rst;
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches_in;
    
    wire [31:0] readData;
    wire [15:0] leds_out;

    addressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches_in(switches_in),
        .readData(readData),
        .leds_out(leds_out)
    );

    always #5 clk = ~clk; // 10ns clock period

    initial begin
        clk = 0;
        rst = 1;
        address = 0;
        readEnable = 0;
        writeEnable = 0;
        writeData = 0;
        switches_in = 16'h5A5A;
        
        #20;
        rst = 0;
        #10;
        
        // 1. Write to Data Memory (Address 4, range 0-511)
        address = 32'h00000004;
        writeData = 32'h000000FF;
        writeEnable = 1;
        #10;
        writeEnable = 0;
        #10;
        
        // 2. Read from Data Memory
        readEnable = 1;
        #10;
        readEnable = 0;
        #10;
        
        // 3. Write to LEDs (Address 512 = 0x200, range 512-767)
        address = 32'h00000200;
        writeData = 32'h00001234;
        writeEnable = 1;
        #10;
        writeEnable = 0;
        #10;
        
        // 4. Read from Switches (Address 768 = 0x300, range 768-1023)
        address = 32'h00000300; 
        readEnable = 1;
        #10;
        readEnable = 0;
        #20;
        
        $finish;
    end
endmodule
