`timescale 1ns/1ps

module tb_moving_average_4;

reg clk = 0;
reg rst_n = 0;
reg [15:0] sample_in = 0;
reg valid_in = 0;
wire [15:0] avg_out;
wire valid_out;

moving_average_4 dut (
    .clk(clk),
    .rst_n(rst_n),
    .sample_in(sample_in),
    .valid_in(valid_in),
    .avg_out(avg_out),
    .valid_out(valid_out)
);

always #5 clk = ~clk;

initial begin
    $display("Starting tb_moving_average_4");
    #20 rst_n = 1;

    @(posedge clk); sample_in <= 16'd10; valid_in <= 1'b1;
    @(posedge clk); sample_in <= 16'd14; valid_in <= 1'b1;
    @(posedge clk); sample_in <= 16'd18; valid_in <= 1'b1;
    @(posedge clk); sample_in <= 16'd22; valid_in <= 1'b1;
    @(posedge clk); sample_in <= 16'd26; valid_in <= 1'b1;
    @(posedge clk); valid_in <= 1'b0;

    repeat (5) @(posedge clk);

    $display("avg_out = %d, valid_out = %b", avg_out, valid_out);
    $finish;
end

endmodule
