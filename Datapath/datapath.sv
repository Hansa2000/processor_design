module datapath (
	input logic clk,
	input logic reset,
	input logic [4:0] reg1_addr,
	input logic [4:0] reg2_addr,
	input logic [4:0] write_reg_addr,
	input logic ctrl0, //regfile write enable 
	input logic ctrl1, //mux1 control signal
	input logic ctrl2, //mux2 control signal
	input logic ctrl3, //mem read control signal
	input logic ctrl4, //mem write control signal
	input logic [2:0] ALUOp,	
	input logic [31:0] instruction,
	output logic ZeroFlag

);

logic [31:0] wire_mux_to_regfile;
logic [31:0] reg1_to_A;
logic [31:0] reg2_out;
logic [31:0] alu_out;
logic [31:0] imm;
logic [31:0] mux2_to_B;
logic [31:0] mem_out;

RegisterFile reg_file (
	.clk(clk),          
    	.reset(reset),           
    	.reg1_addr(reg1_addr), 
    	.reg2_addr(reg2_addr), 
    	.write_reg_addr(write_reg_addr), 
    	.write_enable(ctrl0),   
    	.write_data(wire_mux_to_regfile), 
    	.reg1_out(reg1_to_A), 
 	.reg2_out(reg2_out) 
);

ImmGen immgen (
    .instruction(instruction), 
    .imm(imm)           
);


mux32 mux1(
	.data0(mem_out),  // 32-bit input data 0
    	.data1(alu_out),  // 32-bit input data 1
   	.select(ctrl1),        // Selection control (0 selects data0, 1 selects data1)
    	.out(wire_mux_to_regfile) // 32-bit out
);

mux32 mux2(
	.data0(reg2_out),  
    	.data1(imm),  
   	.select(ctrl2),       
    	.out(mux2_to_B) 
);

ALU alu(
    	.A(reg1_to_A),
    	.B(mux2_to_B),
    	.ALUOp(ALUOp),
    	.Result(alu_out),
    	.ZeroFlag(ZeroFlag)
);
	
DataMemory data_mem (
    .clk(clk),           
    .address(alu_out), 
    .write_data(reg2_out), 
    .mem_read(ctrl3),      
    .mem_write(ctrl4),     
    .read_data(mem_out) 
);



endmodule




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
        end 
    end

     always @(!clk) begin
		if (write_enable) begin
            // Write data to the specified register address when write_enable is active
            registers[write_reg_addr] <= write_data;
        end
    end

    // Read data from the specified registers based on the provided addresses
    assign reg1_out = (reg1_addr == 0) ? 32'h00000000 : registers[reg1_addr];   //zero reg is hardwired to zero
    assign reg2_out = (reg2_addr == 0) ? 32'h00000000 : registers[reg2_addr];

endmodule


module ALU (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [2:0]  ALUOp,
    output logic [31:0] Result,
    output logic ZeroFlag
);
    always @(*) begin
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

endmodule 

module mux32 (
    input wire [31:0] data0,  // 32-bit input data 0
    input wire [31:0] data1,  // 32-bit input data 1
    input wire select,        // Selection control (0 selects data0, 1 selects data1)
    output wire [31:0] out // 32-bit out
);

    assign out = (select) ? data1 : data0;

endmodule




module ImmGen(
    input wire [31:0] instruction,  // 32-bit instruction input
    output logic [31:0] imm           // Immediate output
);
    reg [6:0] opcode; 
    assign opcode = instruction[6:0];  // Extract the least significant 7 bits as opcode

    always_comb begin
        

        case (opcode)
            // LUI instruction
            7'b0110111: imm = {instruction[31:12],12'b0};

            // AUIPC instruction
            7'b0010111: imm = {instruction[31:12],12'b0};

            // JAL instruction
            7'b1101111: imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
 
            // JALR instruction
            7'b1100111: imm = {{20{instruction[31]}}, instruction[31:20]};

            // Branch instructions
            7'b1100011: imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};

	    // L instructions
            7'b0000011: imm = {{20{instruction[31]}}, instruction[31:20]};

	    // S instructions
            7'b0100011: imm = {{20{instruction[31]}},instruction[31:25], instruction[11:7]};
	  
 	    // Arithematic I instructions
            7'b0010011: imm = {{20{instruction[31]}}, instruction[31:20]};

	    // Shift I instructions
	    7'b0010011: imm = {27'b0, instruction[24:20]};



            // Add more cases for other instructions as needed

            default: imm = 32'b0; // Default immediate value
        endcase
    end

endmodule


module DataMemory (
    input logic clk,           // Clock signal
    input logic [31:0] address, // Address for read or write
    input logic [31:0] write_data, // Data to be written to memory
    input logic mem_read,      // Memory read control signal
    input logic mem_write,     // Memory write control signal
    output wire [31:0] read_data // Data read from memory
);

    reg [31:0] memory [0:1023]; // Declare memory as an array of 1024 registers

    always @(!clk) begin
        if (mem_write) begin
            // Write data to memory at the specified address when MemWrite is active
            memory[address] <= write_data;
        end
    end

    assign read_data = (mem_read) ? memory[address] : 32'hz;


endmodule


