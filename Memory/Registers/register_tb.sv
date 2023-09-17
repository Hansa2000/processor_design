module registers_tb;

    reg clk;                                // Clock signal
    reg reset_all;                          // Reset signal for all registers
    reg [31:0] write_en_all;               // Write enable for all registers
    reg [31:0] read_en_a_all;              // Read enable A for all registers
    reg [31:0] read_en_b_all;              // Read enable B for all registers
    reg [31:0] bus_a;                      // Bus A
    reg [31:0] bus_b;                      // Bus B
    reg [31:0] bus_c;                      // Bus C

    // Instantiate the registers module
    registers uut (
        .clk(clk),
        .reset_all(reset_all),
        .write_en_all(write_en_all),
        .read_en_a_all(read_en_a_all),
        .read_en_b_all(read_en_b_all),
        .bus_a(bus_a),
        .bus_b(bus_b),
        .bus_c(bus_c)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle the clock every 5 time units
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        clk = 1;
        reset_all = 1;
        write_en_all = 0;
        read_en_a_all = 0;
        read_en_b_all = 0;
        bus_c = 0;

        // Apply reset to all registers
        #10 reset_all = 0;
        #10 reset_all = 1;

        // Write data to individual registers
        for (int i = 0; i < 32; i = i + 1) begin
            write_en_all[i] = 1;
            bus_c = 32'hA5A5A5A5 + i; // Unique data for each register
            #10 write_en_all[i] = 0;
        end

        // Read data from individual registers
        for (int i = 0; i < 32; i = i + 1) begin
            read_en_a_all[i] = 1;
            read_en_b_all[i] = 1;
            #10 read_en_a_all[i] = 0;
            #10 read_en_b_all[i] = 0;
        end

        // Display results (you can add more checks based on your design)
        $display("Data from Register 0 (Bus A): %h", bus_a[0]);
        $display("Data from Register 0 (Bus B): %h", bus_b[0]);

        // Finish simulation
        $finish;
    end

endmodule
