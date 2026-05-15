`timescale 1ns / 1ps

module spi_clk_div (
    input  wire       sys_clk,
    input  wire       sys_rst_n,
    input  wire [7:0] clk_div,
    input  wire       en,
    output reg        fall_en,
    output reg        rise_en
);

    reg       phase;
    reg [7:0] count;

   always @(posedge sys_clk) begin
    if (!sys_rst_n) begin
        count   <= 8'd0;
        phase   <= 1'b0;
        fall_en <= 1'b0;
        rise_en <= 1'b0;
    end else begin
        fall_en <= 1'b0;
        rise_en <= 1'b0;

        if (!en) begin
            count <= 8'd0;
        end else begin
            if (count == clk_div) begin
                count <= 8'd0;

                if (phase == 1'b0) begin
                    fall_en <= 1'b1;
                    phase   <= 1'b1;
                end else begin
                    rise_en <= 1'b1;
                    phase   <= 1'b0;
                end
            end else begin
                count <= count + 8'd1;
            end
        end
    end
end

endmodule