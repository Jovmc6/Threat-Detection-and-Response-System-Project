`timescale 1ns / 1ps
module threat_classifier(
    input  wire [7:0] distance_cm,
    input  wire [7:0] velocity_idx,
    output reg  [3:0] led,
    output reg  [1:0] threat_level
);

reg [3:0] score;

always @(*) begin
    score = 4'd0;

    // Distance score
    if (distance_cm < 8'd40)
        score = score + 4'd4;
    else if (distance_cm < 8'd100)
        score = score + 4'd2;

    // Velocity score
    if (velocity_idx > 8'd6)
        score = score + 4'd4;
    else if (velocity_idx > 8'd2)
        score = score + 4'd2;

    // Threat classification
    if (score >= 4'd6) begin
        threat_level = 2'd2;   // HIGH
        led = 4'b0100;         // LED2
    end else if (score >= 4'd3) begin
        threat_level = 2'd1;   // MEDIUM
        led = 4'b0010;         // LED1
    end else begin
        threat_level = 2'd0;   // LOW
        led = 4'b0001;         // LED0
    end
end

endmodule