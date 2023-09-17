module RegisterFile (
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire [4:0] reg1_addr, // Address for reading from register 1
    input wire [4:0] reg2_addr, // Address for reading from register 2
    input wire [4:0] write_reg_addr, // Address for writing to a register
    input wire write_enable,   // Write enable signal
    input wire [31:0] write_data, // Data to be written to the register file
    output wire [31:0] reg1_out, // Data output from register 1
    output wire [31:0] reg2_out // Data output from register 2
);

     reg [31:0] registers [0:31]; // 32 registers in the register file

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reset all registers to 0
            for (int i = 0; i <= 31; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (write_enable) begin
            // Write data to the specified register address when write_enable is active
            registers[write_reg_addr] <= write_data;
        end
    end

    // Read data from the specified registers based on the provided addresses
    assign reg1_out = (reg1_addr == 0) ? 32'h00000000 : registers[reg1_addr];   //zero reg is hardwired to zero
    assign reg2_out = (reg2_addr == 0) ? 32'h00000000 : registers[reg2_addr];

endmodule
