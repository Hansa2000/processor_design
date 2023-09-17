module mux32 (
    input wire [31:0] data0,  // 32-bit input data 0
    input wire [31:0] data1,  // 32-bit input data 1
    input wire select,        // Selection control (0 selects data0, 1 selects data1)
    output wire [31:0] out // 32-bit out
);

    assign out = (select) ? data1 : data0;

endmodule
