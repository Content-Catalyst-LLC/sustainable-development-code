module sensor_capture #(
    parameter ADC_WIDTH = 12
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire [ADC_WIDTH-1:0]  adc_sample,
    input  wire                  adc_valid,
    output reg  [15:0]           sample_count,
    output reg  [ADC_WIDTH-1:0]  latest_sample
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sample_count  <= 16'd0;
        latest_sample <= {ADC_WIDTH{1'b0}};
    end else if (adc_valid) begin
        latest_sample <= adc_sample;
        sample_count  <= sample_count + 16'd1;
    end
end

endmodule
