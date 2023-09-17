module DataMemory (
    input wire clk,           // Clock signal
    input wire [31:0] address, // Address for read or write
    input wire [31:0] write_data, // Data to be written to memory
    input wire mem_read,      // Memory read control signal
    input wire mem_write,     // Memory write control signal
    output wire [31:0] read_data // Data read from memory
);

    reg [31:0] memory [0:1023]; // Declare memory as an array of 1024 registers

    always @(posedge clk) begin
        if (mem_write) begin
            // Write data to memory at the specified address when MemWrite is active
            memory[address] <= write_data;
        end
    end

    assign read_data = (mem_read) ? memory[address] : 32'hz;


endmodule
