module ALU (
    input logic clk,
    input logic rst_n,
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [2:0]  ALUOp,
    output logic [31:0] Result,
    output logic ZeroFlag
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Result <= 32'b0;
            ZeroFlag <= 1'b0;
        end else begin
            case (ALUOp)
                3'b000:  begin Result <= A + B; ZeroFlag <= ((A+B) == 32'b0) ? 1'b1 : 1'b0; end  		// Addition
                3'b001:  begin Result <= A - B; ZeroFlag <= ((A - B) == 32'b0) ? 1'b1 : 1'b0; end  		// Subtraction
                3'b010:  begin Result <= A << B; ZeroFlag <= ((A << B) == 32'b0) ? 1'b1 : 1'b0; end 		// Left Shift Logical (SLL)
                3'b011:  begin Result <= A >>> B; ZeroFlag <= ((A >>> B) == 32'b0) ? 1'b1 : 1'b0; end		// Right Shift Logical (SRL)
                3'b100:  begin Result <= A >>> B; ZeroFlag <= (( A >>> B) == 32'b0) ? 1'b1 : 1'b0; end		// Right Shift Arithmetic (SRA)
                3'b101:  begin Result <= A & B;  ZeroFlag <= ((A & B) == 32'b0) ? 1'b1 : 1'b0; end		// Bitwise AND
                3'b110:  begin Result <= A | B;  ZeroFlag <= ((A | B) == 32'b0) ? 1'b1 : 1'b0; end		// Bitwise OR
                3'b111:  begin Result <= A ^ B;  ZeroFlag <= ((A ^ B) == 32'b0) ? 1'b1 : 1'b0; end		// Bitwise XOR
                default: begin Result <= 32'b0; ZeroFlag <= 32'b0; end						// Default operation
            endcase
        end
    end

endmodule 
