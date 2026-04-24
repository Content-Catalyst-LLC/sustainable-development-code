module moving_average_4 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] sample_in,
    input  wire        valid_in,
    output reg  [15:0] avg_out,
    output reg         valid_out
);

reg [15:0] s0, s1, s2, s3;
reg [17:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s0 <= 16'd0; s1 <= 16'd0; s2 <= 16'd0; s3 <= 16'd0;
        sum <= 18'd0;
        avg_out <= 16'd0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        s3 <= s2;
        s2 <= s1;
        s1 <= s0;
        s0 <= sample_in;

        sum <= s0 + s1 + s2 + s3;
        avg_out <= sum[17:2];
        valid_out <= 1'b1;
    end else begin
        valid_out <= 1'b0;
    end
end

endmodule
