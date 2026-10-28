module DataMemory (
    input clk,
    input rst,
    input MemWrite,               // write = 1, read = 0
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    // 512 locations, 32-bit width memory array[cite: 7]
    reg [31:0] mem [0:511];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data <= 32'b0;
        end else if (MemWrite == 1'b1) begin
            mem[address[8:0]] <= write_data; // Use lower bits for local address
        end else begin
            read_data <= mem[address[8:0]];
        end
    end

endmodule
