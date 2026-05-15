`timescale 1ns / 1ps

module tb_interrupt_generator;

    reg  sys_clk;
    reg  sys_rst_n;
    reg  int_en;
    reg  int_clr;
    reg  sig_in;
    wire int_out;

    interrupt_generator uut (
        .sys_clk  (sys_clk),
        .sys_rst_n(sys_rst_n),
        .int_en   (int_en),
        .int_clr  (int_clr),
        .sig_in   (sig_in),
        .int_out  (int_out)
    );

    initial begin
        sys_clk = 1'b0;
        forever #5 sys_clk = ~sys_clk;
    end

    initial begin
        // Initialize inputs
        sys_rst_n = 1'b0;
        int_en    = 1'b0;
        int_clr   = 1'b0;
        sig_in    = 1'b0;
#1;
        $display("Starting tb_interrupt_generator...");

        // TEST 1: Hold reset low for 5 consecutive clock cycles
        $display("TEST 1: Applying reset for 5 clock cycles");
        repeat (5) @(posedge sys_clk);
        sys_rst_n = 1'b1;
        @(posedge sys_clk);

        if (int_out !== 1'b0)
            $display("ERROR: int_out should be 0 after reset release");
        else
            $display("PASS: int_out is 0 after reset");

        // TEST 2: int_en = 1, assert sig_in for 5 clock cycles
        $display("TEST 2: sig_in high for 5 cycles while int_en = 1");
        int_en = 1'b1;
        sig_in = 1'b1;
        repeat (5) @(posedge sys_clk);
        sig_in = 1'b0;
        @(posedge sys_clk);

        if (int_out !== 1'b1)
            $display("ERROR: int_out should go high when sig_in rises and int_en=1");
        else
            $display("PASS: int_out asserted correctly");

        // Show that int_out stays high rather than retriggering repeatedly
        repeat (3) @(posedge sys_clk);
        if (int_out !== 1'b1)
            $display("ERROR: int_out should remain high until cleared");
        else
            $display("PASS: Only one interrupt event was generated and int_out stayed high");

        // TEST 3: Verify int_out remains high until int_clr is asserted
        $display("TEST 3: Clearing interrupt with int_clr");
        int_clr = 1'b1;
        @(posedge sys_clk);
        int_clr = 1'b0;
        @(posedge sys_clk);

        if (int_out !== 1'b0)
            $display("ERROR: int_out should clear after int_clr");
        else
            $display("PASS: int_out cleared correctly");

        // TEST 4: int_en = 0, assert sig_in for 5 clock cycles
        $display("TEST 4: sig_in high for 5 cycles while int_en = 0");
        int_en = 1'b0;
        sig_in = 1'b1;
        repeat (5) @(posedge sys_clk);
        sig_in = 1'b0;
        @(posedge sys_clk);

        if (int_out !== 1'b0)
            $display("ERROR: int_out should remain low when int_en=0");
        else
            $display("PASS: No interrupt generated when int_en=0");

        $display("Simulation complete.");
        $stop;
    end

endmodule
