module ALU (
    input logic [31:0] operandA,
    input logic [31:0] operandB,
    input logic [2:0] ALUOp,
    input logic [5:0] funct3,
    output logic zero,
    output logic [31:0] result
);
    
    // Perform the ALU operations based on ALUOp and funct3
    always_comb begin
        case (ALUOp)
            3'b000: // ALUOp = 000, ADD
                result = operandA + operandB;
            3'b001: // ALUOp = 001, SUB
                result = operandA - operandB;
            3'b010: // ALUOp = 010, AND
                result = operandA & operandB;
            3'b011: // ALUOp = 011, OR
                result = operandA | operandB;
            3'b100: // ALUOp = 100, XOR
                result = operandA ^ operandB;
            3'b101: // ALUOp = 101, SLL
                result = operandA << operandB[4:0];
            3'b110: // ALUOp = 110, SRL
                result = operandA >> operandB[4:0];
            3'b111: // ALUOp = 111, SRA
                result = $signed(operandA) >>> operandB[4:0];
            default:
                result = 32'b0;
        endcase
    end

    // Set the zero flag if the result is zero
    assign zero = (result == 32'b0);

endmodule
