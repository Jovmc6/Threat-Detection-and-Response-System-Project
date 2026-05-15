`timescale 1ns / 1ps
module spi_master (
    input  wire        sys_clk,
    input  wire        sys_rst_n,
    input  wire        spi_en,
    input  wire [7:0]  clk_div,
    input  wire        start,
    input  wire [15:0] tx_data,
    input  wire        miso,

    output wire        cs_n,
    output wire        sclk,
    output wire        mosi,
    output wire [15:0] rx_data,
    output wire        busy,
    output wire        done
);

    // Internal interconnect signals
    wire fall_en;
    wire rise_en;
    wire clk_div_en;
    wire load;
    wire latch_rx;
    wire assert_cs;
    wire deassert_cs;

    spi_clk_div u_spi_clk_div (
        .sys_clk (sys_clk),
        .sys_rst_n(sys_rst_n),
        .clk_div (clk_div),
        .en      (clk_div_en),
        .fall_en (fall_en),
        .rise_en (rise_en)
    );

    spi_shift_reg u_spi_shift_reg (
        .sys_clk (sys_clk),
        .sys_rst_n(sys_rst_n),
        .fall_en (fall_en),
        .rise_en (rise_en),
        .load    (load),
        .tx_data (tx_data),
        .miso    (miso),
        .latch_rx(latch_rx),
        .mosi    (mosi),
        .rx_data (rx_data)
    );

    spi_cs_ctrl u_spi_cs_ctrl (
        .sys_clk    (sys_clk),
        .sys_rst_n  (sys_rst_n),
        .assert_cs  (assert_cs),
        .deassert_cs(deassert_cs),
        .cs_n       (cs_n)
    );

    spi_fsm u_spi_fsm (
        .sys_clk    (sys_clk),
        .sys_rst_n  (sys_rst_n),
        .spi_en     (spi_en),
        .start      (start),
        .fall_en    (fall_en),
        .rise_en    (rise_en),
        .sclk       (sclk),
        .clk_div_en (clk_div_en),
        .load       (load),
        .latch_rx   (latch_rx),
        .assert_cs  (assert_cs),
        .deassert_cs(deassert_cs),
        .busy       (busy),
        .done       (done)
    );

endmodule