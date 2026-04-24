module irrigation_rule (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] soil_moisture,
    input  wire [15:0] threshold_low,
    input  wire [15:0] threshold_high,
    output reg         valve_open
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valve_open <= 1'b0;
    end else begin
        if (soil_moisture < threshold_low)
            valve_open <= 1'b1;
        else if (soil_moisture > threshold_high)
            valve_open <= 1'b0;
    end
end

endmodule
