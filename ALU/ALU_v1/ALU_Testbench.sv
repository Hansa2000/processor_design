module ALU_Testbench;

    // Inputs
    reg [31:0] operandA;
    reg [31:0] operandB;
    reg [2:0] ALUOp;
    reg [5:0] funct3;

    // Outputs
    wire zero;
    wire [31:0] result;

    // Instantiate the ALU module
    ALU uut (
        .operandA(operandA),
        .operandB(operandB),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .zero(zero),
        .result(result)
    );

    // Clock generation
    reg clock = 0;
    // Provide a clock signal
    always begin
        #5 clock = ~clock;
    end

    // Test cases
    initial begin
        // Test case 1: ADD
        operandA = 8'h0A;
        operandB = 8'h05;
        ALUOp = 3'b000; // ADD
        funct3 = 6'b000000; // funct3 doesn't matter for ADD
        #10;
        if (result !== 8'h0F || zero !== 0) $display("Test case 1 failed");
        else $display("Test case 1 passed");

        // Test case 2: SUB
        operandA = 8'h0A;
        operandB = 8'h05;
        ALUOp = 3'b001; // SUB
        funct3 = 6'b000000; // funct3 doesn't matter for SUB
        #10;
        if (result !== 8'h05 || zero !== 0) $display("Test case 2 failed");
        else $display("Test case 2 passed");

        // Add more test cases for other ALU operations here...

        // Test case 3: AND
        operandA = 8'h0A;
        operandB = 8'h05;
        ALUOp = 3'b010; // AND
        funct3 = 6'b000000; // funct3 doesn't matter for AND
        #10;
        if (result !== 8'h00 || zero !== 1) $display("Test case 3 failed");
        else $display("Test case 3 passed");

        // Finish with a $finish
        $finish;
    end

endmodule
