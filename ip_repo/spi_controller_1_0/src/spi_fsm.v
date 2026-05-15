`timescale 1ns / 1ps
module spi_fsm (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire spi_en,
    input  wire start,
    input  wire fall_en,
    input  wire rise_en,

    output reg  sclk,
    output reg  clk_div_en,
    output reg  load,
    output reg  latch_rx,
    output reg  assert_cs,
    output reg  deassert_cs,
    output reg  busy,
    output reg  done
);

    reg [1:0] state;
    reg [4:0] bit_count;

    localparam IDLE     = 2'd0;
    localparam TRANSFER = 2'd1;
    localparam DONE     = 2'd2;

    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            state       <= IDLE;
            bit_count   <= 5'd0;
            sclk        <= 1'b1;
            clk_div_en  <= 1'b0;
            load        <= 1'b0;
            latch_rx    <= 1'b0;
            assert_cs   <= 1'b0;
            deassert_cs <= 1'b0;
            busy        <= 1'b0;
            done        <= 1'b0;
        end else begin
            // default one-cycle pulses
            load        <= 1'b0;
            latch_rx    <= 1'b0;
            assert_cs   <= 1'b0;
            deassert_cs <= 1'b0;
            done        <= 1'b0;

            case (state)
                IDLE: begin
                    sclk       <= 1'b1;
                    clk_div_en <= 1'b0;
                    busy       <= 1'b0;
                    bit_count  <= 5'd0;

                    if (start && spi_en) begin
                        load       <= 1'b1;
                        assert_cs  <= 1'b1;
                        busy       <= 1'b1;
                        state      <= TRANSFER;
                    end
                end

                TRANSFER: begin
                    clk_div_en <= 1'b1;
                    busy       <= 1'b1;

                    if (fall_en) begin
                        sclk <= 1'b0;
                    end

                    if (rise_en) begin
                        sclk <= 1'b1;

                        if (bit_count == 5'd15) begin
                            bit_count <= 5'd16;
                            latch_rx  <= 1'b1;
                            state     <= DONE;
                        end else begin
                            bit_count <= bit_count + 5'd1;
                        end
                    end
                end

                DONE: begin
                    sclk        <= 1'b1;
                    clk_div_en  <= 1'b0;
                    busy        <= 1'b0;
                    done        <= 1'b1;
                    deassert_cs <= 1'b1;
                    state       <= IDLE;
                end

                default: begin
                    state       <= IDLE;
                    bit_count   <= 5'd0;
                    sclk        <= 1'b1;
                    clk_div_en  <= 1'b0;
                    load        <= 1'b0;
                    latch_rx    <= 1'b0;
                    assert_cs   <= 1'b0;
                    deassert_cs <= 1'b0;
                    busy        <= 1'b0;
                    done        <= 1'b0;
                end
            endcase
        end
    end

endmodule