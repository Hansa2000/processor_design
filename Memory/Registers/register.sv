module Register (
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire write_enable,       // Register write control signal
    input wire read_enable,     // Read enable control signal
    input wire [31:0] write_data, // Data to be written
    inout [31:0] z              // High-impedance outputs when not reading
);
    reg [31:0] data;  // Register
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reset the register to zero
            data <= 32'b0;
        end else if (write_enable) begin
            // Write data to the register when the write control is active
            data <= write_data;
        end
    end

    // Tri-state buffer control
    assign z = (read_enable) ? 32'bz : data;

endmodule
