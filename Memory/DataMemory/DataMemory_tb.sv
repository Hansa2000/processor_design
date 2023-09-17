module DataMemory_tb;

    reg clk;
    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_read;
    reg mem_write;
    wire [31:0] read_data;

    // Instantiate the DataMemory module
    DataMemory uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    integer i;
    integer num_registers = 10;

    // Initialize signals
    initial begin
        // Initialize clock and control signals
        clk = 0;
        address = 0;
        write_data = 0;
        mem_read = 0;
        mem_write = 0;

        // Write to ten random registers
        for (i = 0; i < num_registers; i = i + 1) begin
            mem_write = 1;
            address = $random % 32; // Generate a random address between 0 and 31
            write_data = $random;   // Generate a random data value
            #10 mem_write = 0;
        end

        // Read from the same ten registers
        for (i = 0; i < num_registers; i = i + 1) begin
            mem_read = 1;
            address = i; // Sequentially read from registers 0 to 9
            #10 mem_read = 0;
        end

        // Perform simultaneous write-read operations
        mem_write = 1;
        address = 20; // Write to register 20
        write_data = 32'hABCDEFFA;
        mem_read = 1;
        address = 20; // Read from register 20
        #10 mem_write = 0;
        #10 mem_read = 0;

        // Finish simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
