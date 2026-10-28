
module AddressDecoder (
    input [31:0] address,
    input cpu_memWrite,
    input cpu_memRead,
    
    output DataMemWrite,
    output DataMemRead,
    output LEDWrite,
    output SwitchReadEnable
);

    wire [1:0] selector;
    
    // Select device using address bits [9:8]
    assign selector = address[9:8];

    // Decode signals based on instructor's table
    // Data Memory is selected if selector is 00 OR 01
    assign DataMemWrite     = (selector == 2'b00 || selector == 2'b01) ? cpu_memWrite : 1'b0;
    assign DataMemRead      = (selector == 2'b00 || selector == 2'b01) ? cpu_memRead  : 1'b0;
    
    // LEDs selected if selector is 10
    assign LEDWrite         = (selector == 2'b10) ? cpu_memWrite : 1'b0;
    
    // Switches selected if selector is 11
    assign SwitchReadEnable = (selector == 2'b11) ? cpu_memRead  : 1'b0;

endmodule

