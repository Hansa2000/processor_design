module mux_tb;

    reg [31:0] data0, data1;
    reg select;
    wire [31:0] out;

    // Instantiate the Mux2to1_32bit module
    Mux2to1_32bit uut (
        .data0(data0),
        .data1(data1),
        .select(select),
        .out(out)
    );

    // Initialize signals
    initial begin
        // Test case 1: Select data0 (select = 0)
        data0 = 32'hABCDEFFA;
        data1 = 32'h12345678;
        select = 0;

        // Test case 2: Select data1 (select = 1)
        data0 = 32'hABCDEF12;
        data1 = 32'h98765432;
        select = 1;

        // Simulate for a few clock cycles
        #10;

        // Display results
        $display("Test Case 1: Select data0 (select = 0)");
        $display("Output: %h", out);

        $display("Test Case 2: Select data1 (select = 1)");
        $display("Output: %h", out);

        // Finish simulation
        $finish;
    end

endmodule