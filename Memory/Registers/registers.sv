module registers(
	input	reg clk,
	input	reg reset_all,
	input	wire [31:0] write_en_all,
	input	wire [31:0] read_en_a_all,
	input	wire [31:0] read_en_b_all,
	output	wire [31:0] bus_a,
	output	wire [31:0] bus_b,
	input	wire [31:0] bus_c
);

	generate
        	genvar i;
        	for (i = 0; i < 32; i = i + 1) begin : reg_block
            		Register #(i) reg_inst (
                		.clk(clk),
                		.reset(reset_all),
						   .write_enable(write_en_all[i]),
					      .read_enable_a( read_en_a_all[i]),
							.read_enable_b( read_en_b_all[i]),
                		.write_data(bus_c),
							.a(bus_a),
							.b(bus_b)
            	);
        	end
    endgenerate


endmodule

module Register #(int instance_num)(
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire write_enable,       // Register write control signal
    input wire read_enable_a,     // Read enable control signal
	 input wire read_enable_b,     // Read enable control signal
    input wire [31:0] write_data, // Data to be written
    inout [31:0] a,              // High-impedance outputs when not reading, out a bus
	 inout [31:0] b					 // High-impedance outputs when not reading, out b bus
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
    assign a = (!read_enable_a) ? 32'bz : data;
	 assign b = (!read_enable_b) ? 32'bz : data;

endmodule
