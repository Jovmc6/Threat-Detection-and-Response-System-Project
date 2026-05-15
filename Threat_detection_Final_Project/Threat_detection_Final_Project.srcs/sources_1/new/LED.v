module LED(

    input  wire       rst,
    input  wire       sys_clk,
    input  wire       sw0,
    input  wire       sw1,
    input  wire       sw2,
    output wire [3:0] count_out
);

wire [7:0] distance_cm;
wire [7:0] velocity_idx;
wire [1:0] threat_level;
wire [1:0] action;
wire [3:0] led_fsm;

assign distance_cm  = sw0 ? 8'd30 : 8'd120;
assign velocity_idx = sw1 ? 8'd7  : 8'd0;

threat_classifier classifier1(
    .distance_cm(distance_cm),
    .velocity_idx(velocity_idx),
    .led(),
    .threat_level(threat_level)
);

response_fsm fsm1(
    .rst(rst),
    .sys_clk(sys_clk),
    .threat_level(threat_level),
    .action(action),
    .led(led_fsm)
);

assign count_out = led_fsm;

endmodule