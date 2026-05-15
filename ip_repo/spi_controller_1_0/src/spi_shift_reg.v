`timescale 1ns / 1ps


module spi_shift_reg (
    input  wire        sys_clk,
    input  wire        sys_rst_n,
    input  wire        fall_en,
    input  wire        rise_en,
    input  wire        load,
    input  wire [15:0] tx_data,
    input  wire        miso,
    input  wire        latch_rx,
    output wire        mosi,
    output reg  [15:0] rx_data
);

    reg [15:0] tx_shift_reg;
    reg [15:0] rx_shift_reg;
//MOSI continuously reflects the MSB of the transmit shit register
    assign mosi = tx_shift_reg[15];

    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            tx_shift_reg <= 16'h0000;
            rx_shift_reg <= 16'h0000;
            rx_data      <= 16'h0000;
        end else begin
        //highest priority to load tx_data
            if (load) begin
                tx_shift_reg <= tx_data;
            end 
            
            else if (fall_en) begin
                tx_shift_reg <= {tx_shift_reg[14:0], 1'b0};
            end
            // shift recieve register left and sample MISO into LSB
            if (rise_en) begin
                rx_shift_reg <= {rx_shift_reg[14:0], miso};
            end
            // Latch into rx_data when transfer completes
            if (latch_rx) begin
                rx_data <= rx_shift_reg;
            end
        end
    end

endmodule