`timescale 1ns / 1ps

module tb_timing();

    // Setup inputs and outputs
    reg clk;
    reg rst_btn;
    reg [15:0] sw;

    wire [6:0] seg;
    wire [3:0] an;
    wire [15:0] led;

    // Plug into your main code
    top uut (
        .clk(clk),
        .rst_btn(rst_btn),
        .sw(sw),
        .seg(seg),
        .an(an),
        .led(led)
    );

    // Create a 100MHz clock (flips every 5ns, full wave is 10ns)
    always #5 clk = ~clk;

    initial begin
        // ----------------------------------------------------
        // WAVEFORM GENERATION CODE
        // This creates the file that holds the timing diagram
        // ----------------------------------------------------
        $dumpfile("timing_diagram.vcd"); // Name of the output file
        $dumpvars(0, tb_timing);         // Record everything in this testbench
        
        // 1. Initialize to zero
        clk = 0;
        rst_btn = 0;
        sw = 16'b0;

        // 2. Press and release the Reset button
        #50;
        rst_btn = 1;
        #50;
        rst_btn = 0;
        #100; // Wait a bit for the system to settle

        // 3. Test 1: Start a countdown from 4 (Binary 0100)
        // Flip switch 2 on
        sw = 16'b0000_0000_0000_0100; 
        
        // Wait for debounce and the countdown to hit zero
        // (Since we hacked the clock divider to 100, each "second" is only ~1000ns)
        #6000; 

        // 4. Test 2: Start a new countdown from 2 (Binary 0010)
        sw = 16'b0000_0000_0000_0010;
        
        // Wait long enough for it to count 2 -> 1 -> 0
        #4000;

        // 5. Test 3: Change switches *during* a countdown to see it restart
        sw = 16'b0000_0000_0000_0011; // Set to 3
        #1500;                        // Wait only 1.5 "seconds"
        sw = 16'b0000_0000_0000_0101; // Interrupt and change to 5
        
        // Wait for it to finish counting down from 5
        #7000;

        // Stop the simulation
        $display("Waveform generated successfully!");
        $finish;
    end

endmodule
