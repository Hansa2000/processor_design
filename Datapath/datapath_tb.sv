module datapath_tb;

logic clk;
logic reset;
logic [4:0] reg1_addr;
logic [4:0] reg2_addr;
logic [4:0] write_reg_addr;
logic ctrl0;
logic ctrl1;
logic ctrl2;
logic ctrl3;
logic ctrl4;
logic [2:0] ALUOp;
logic [31:0] instruction;	
logic ZeroFlag;



// Create a clock generator
always begin
	#5 clk = ~clk; // Toggle the clock every 5 time units
end


initial begin
	clk =1;
	reset = 1;
	ctrl1 = 0;
	ctrl2 = 0;
	ctrl3 = 0;
	ctrl4 = 0;
	instruction = 32'h00000000;
	ALUOp = 3'bz;
	#10 reset = 0;
	#10 reset = 1;

	reg1_addr = 5'b0;
	reg2_addr = 5'b0;
	write_reg_addr = 5'b10010;
	ALUOp = 3'b000;
	instruction = 32'b00000000100000000000000000010011;// addi 8 and store to reg 18
	ctrl1 = 1;
	ctrl2 = 1;
	ctrl3 = 0;
	ctrl4 = 0;
	#10 ctrl0 = 1;
	#10 ctrl0 = 0;
	#10;

	reg1_addr = 5'b0;
	reg2_addr = 5'b0;
	write_reg_addr = 5'b10011;
	ALUOp = 3'b000;
	instruction = 32'b00000000011100000000000000010011;// addi 7 and store to reg 19
	ctrl1 = 1;
	ctrl2 = 1;
	ctrl3 = 0;
	ctrl4 = 0;
	#10 ctrl0 = 1;
	#10 ctrl0 = 0;
	#10;

	reg1_addr = 5'b00000;
	reg2_addr = 5'b10010;
	write_reg_addr = 5'b0;
	instruction = 32'b 00000001001000000010000010100011;// save reg 18 value to mem location 01  , 0000000 10010 00000 010 00001 0100011 
	ALUOp = 3'b000;
	
	ctrl0 = 0;
	ctrl1 = 1;
	ctrl2 = 1;
	ctrl3 = 0;
	#1 ctrl4 = 1;
	#9;
	ctrl4 = 0;

	reg1_addr = 5'b00000;
	reg2_addr = 5'b10011;
	write_reg_addr = 5'b0;
	instruction = 32'b 00000001001000000010000100100011 ;// save reg 18 value to mem location 01  , 0000000 10010 00000 010 00010 0100011 
	ALUOp = 3'b000;
	
	ctrl0 = 0;
	ctrl1 = 1;
	ctrl2 = 1;
	ctrl3 = 0;
	#1 ctrl4 = 1;
	#9;
	#10;
	
end


datapath uut (
	.clk(clk),
	.reset(reset),
	.reg1_addr(reg1_addr),
	.reg2_addr(reg2_addr),
	.write_reg_addr(write_reg_addr),
	.ctrl0(ctrl0),
	.ctrl1(ctrl1),
	.ctrl2(ctrl2),
	.ctrl3(ctrl3),
	.ctrl4(ctrl4),
	.ALUOp(ALUOp),
	.instruction(instruction),	
	.ZeroFlag(ZeroFlag)
);

endmodule