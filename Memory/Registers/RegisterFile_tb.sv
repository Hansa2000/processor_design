module RegisterFile_tb;

    reg clk;
    reg reset;
    reg [4:0] reg1_addr;
    reg [4:0] reg2_addr;
    reg [4:0] write_reg_addr;
    reg write_enable;
    reg [31:0] write_data;

    wire [31:0] reg1_out;
    wire [31:0] reg2_out;

    // Instantiate the RegisterFile module
    RegisterFile uut (
        .clk(clk),
        .reset(reset),
        .reg1_addr(reg1_addr),
        .reg2_addr(reg2_addr),
        .write_reg_addr(write_reg_addr),
        .write_enable(write_enable),
        .write_data(write_data),
        .reg1_out(reg1_out),
        .reg2_out(reg2_out)
    );

    // Initialize signals
    initial begin
        // Initialize inputs
        clk = 1;
        reset = 1;
        reg1_addr = 5'b00000;
        reg2_addr = 5'b00001;
        write_reg_addr = 5'b00010;
        write_enable = 0;
        write_data = 32'hABCDEFFA;

        // Apply reset
        $display("Applying reset...");
        #10 reset = 0;
        #10 reset = 1;
        $display("Reset completed.");

        // Read from registers
        reg1_addr = 5'b00000;
        reg2_addr = 5'b00001;
        #10;
        $display("Read register 1: reg1_out = %h", reg1_out);
        $display("Read register 2: reg2_out = %h", reg2_out);

        // Write to a register
        write_enable = 1;
        write_reg_addr = 5'b00010;
        write_data = 32'h12345678;
        #10;
        write_enable = 0;
        $display("Write data %h to register %d", write_data, write_reg_addr);

        // Read from registers again
        reg1_addr = 5'b00000;
        reg2_addr = 5'b00010;
        #10;
        $display("Read register 1: reg1_out = %h", reg1_out);
        $display("Read register 2: reg2_out = %h", reg2_out);

        // Finish simulation
        $display("Simulation completed.");
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
