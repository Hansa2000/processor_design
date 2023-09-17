module RAM_tb;

    reg clk;                       // Clock signal
    reg reset;                     // Reset signal
    reg [31:0] addr;               // Address for read/write
    reg [31:0] data_in;            // Data to be written
    reg read_enable;               // Read enable signal
    reg write_enable;              // Write enable signal
    wire [31:0] data_out;          // Data read from memory

    // Instantiate the RAM module
    RAM uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle the clock every 5 time units
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        clk = 1;
        reset = 1;
        addr = 0;
        data_in = 0;
        read_enable = 0;
        write_enable = 0;

        // Release reset
        #10 reset = 0;
	#10 reset = 1;

        // Write data to memory locations 0 to 9
        for (int i = 0; i < 10; i = i + 1) begin
            addr = i;
            data_in = 32'hA5A5A5A5 + i;
            write_enable = 1;
            #10 write_enable = 0;
        end

        // Read data from memory locations 0 to 9
        for (int i = 0; i < 10; i = i + 1) begin
            addr = i;
            read_enable = 1;
            #10 read_enable = 0;
            $display("Read Data at Address %d: %h", addr, data_out);
        end

        // Reset memory
        reset = 1;
        #10 reset = 0;

        // Finish simulation
        $finish;
    end

endmodule