module RAM(
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input wire [31:0] addr,        // Address for read/write
    input wire [31:0] data_in,     // Data to be written
    input wire read_enable,        // Read enable signal
    input wire write_enable,       // Write enable signal
    output wire [31:0] data_out    // Data read from memory
);

    reg [31:0] mem [0:1023]; // Memory array with 1023 locations

    // Read and write operations
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reset memory to all zeros
            for (int i = 0; i < 1024; i = i + 1) begin
                mem[i] <= 32'b0;
            end
        end else begin
            if (write_enable) begin
                // Write data to memory
                mem[addr] <= data_in;
            end
        end
    end

    // Read operation
	assign data_out = (read_enable)? mem[addr]:32'bz;

endmodule
