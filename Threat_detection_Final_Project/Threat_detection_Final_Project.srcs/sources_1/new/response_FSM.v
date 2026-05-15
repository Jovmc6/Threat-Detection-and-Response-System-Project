module response_fsm(
    input  wire       rst,
    input  wire       sys_clk,
    input  wire [1:0] threat_level,
    output reg  [1:0] action,
    output reg  [3:0] led
);

always @(posedge sys_clk) begin
    if (rst) begin
        action <= 2'd0;
        led    <= 4'b0000;
    end else begin
        case (threat_level)
            2'd0: begin
                action <= 2'd0;      // MONITOR
                led    <= 4'b0001;   // LED0
            end

            2'd1: begin
                action <= 2'd1;      // ALERT
                led    <= 4'b0010;   // LED1
            end

            2'd2: begin
                action <= 2'd2;      // ENGAGE
                led    <= 4'b1000;   // LED3
            end

            default: begin
                action <= 2'd0;
                led    <= 4'b0000;
            end
        endcase
    end
end

endmodule