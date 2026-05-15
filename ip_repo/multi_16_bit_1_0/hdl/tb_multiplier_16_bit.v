`timescale 1ns / 1ps

module tb_multiplier_16_bit;

    reg clk;
    reg rst_n;
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] prod;

    integer i;
    reg [31:0] expected;

    // Instantiate DUT
    multiplier_16_bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .prod(prod)
    );

    // 125 MHz clock => period = 8 ns
    always #4 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        a = 16'd0;
        b = 16'd0;

        // Hold reset for a few cycles
        #20;
        rst_n = 1'b1;

        // Apply 32 input pairs, one pair per clock cycle
        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clk);
            a <= i;
            b <= (i + 1);
        end

        // Wait a little and finish
        #20;
        $finish;
    end

    // Check output every cycle after reset
    always @(posedge clk) begin
        if (!rst_n) begin
            expected <= 32'd0;
        end else begin
            expected = a * b;
            #1;
            if (prod == expected)
                $display("PASS @ %0t ns: a=%0d b=%0d prod=%0d", $time, a, b, prod);
            else
                $display("FAIL @ %0t ns: a=%0d b=%0d prod=%0d expected=%0d",
                         $time, a, b, prod, expected);
        end
    end
endmodule
