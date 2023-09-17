module ImmediateExtractor_tb;

    reg [31:0] instruction;
    wire [31:0] imm;

    // Instantiate the ImmediateExtractor module
    ImmediateExtractor uut (
        .instruction(instruction),
        .imm(imm)
    );

    // Initialize signals
    initial begin
        // Test case 1: LUI instruction
        instruction = 32'b10100000000000001110110000110111; // LUI instruction with imm = 0x000010C

	// Simulate for a few clock cycles
        #10;

        // Display results
        $display("Instruction: %h", instruction);
        $display("Immediate: %h", imm);

	 // Add more test cases for different instructions here

        // Finish simulation
        $finish;
    end

endmodule
