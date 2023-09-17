module ALU_tb;

  // Define module inputs and outputs
  logic [31:0] A;
  logic [31:0] B;
  logic [2:0] ALUOp;
  logic [31:0] Result;
  logic ZeroFlag;

  // Clock and reset signals
  reg clk;
  reg rst_n;

  // Instantiate the ALU module
  ALU uut (
    .clk(clk),
    .rst_n(rst_n),
    .A(A),
    .B(B),
    .ALUOp(ALUOp),
    .Result(Result),
    .ZeroFlag(ZeroFlag)
  );

  // Create a clock generator
  always begin
    #5 clk = ~clk; // Toggle the clock every 5 time units
  end

  // Initialize signals
  initial begin
    // Initialize inputs
    A = 32'h12345678;
    B = 32'h87654321;
    ALUOp = 3'bxxx; // Addition operation

    // Initialize clock and reset
    clk = 1;
    rst_n = 1;
    #10; 
    rst_n = 0;

    // Apply reset
    #10; // Wait for a few clock cycles
    rst_n = 1;

// Test Addition
ALUOp = 3'b000; // Addition
#10; // Wait for the result

// Test Subtraction
A = 32'h12345678;
B = 32'h12345678;
ALUOp = 3'b001; // Subtraction
#10; // Wait for the result

// Test Left Shift Logical (SLL)
A = 32'h7fffffff;
B = 32'h00000001;
ALUOp = 3'b010;
#10;

// Test Right Shift Logical (SRL)
A = 32'hffffffff;
B = 32'h00000001;
ALUOp = 3'b011;
#10;

// Test Right Shift Arithmetic (SRA)
ALUOp = 3'b100;
#10;

// Test Bitwise AND
A = 32'h0000ffff;
B = 32'h00ffff00;
ALUOp = 3'b101;
#10;

// Test Bitwise OR
ALUOp = 3'b110;
#10;

// Test Bitwise XOR
ALUOp = 3'b111;
#10;

    // You can add more test cases as needed

    // Finish simulation
    //$finish;
  end

  // Display results
  always @(posedge clk) begin
    $display("ALU Operation: %b", ALUOp);
    $display("A: %h", A);
    $display("B: %h", B);
    $display("Result: %h", Result);
    $display("ZeroFlag: %b", ZeroFlag);
    $display("--------------------------");
  end

endmodule