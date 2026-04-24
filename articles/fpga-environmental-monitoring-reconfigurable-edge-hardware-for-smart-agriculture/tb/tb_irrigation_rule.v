`timescale 1ns/1ps

module tb_irrigation_rule;

reg clk = 0;
reg rst_n = 0;
reg [15:0] soil_moisture = 0;
reg [15:0] threshold_low = 16'd300;
reg [15:0] threshold_high = 16'd600;
wire valve_open;

irrigation_rule dut (
    .clk(clk),
    .rst_n(rst_n),
    .soil_moisture(soil_moisture),
    .threshold_low(threshold_low),
    .threshold_high(threshold_high),
    .valve_open(valve_open)
);

always #5 clk = ~clk;

initial begin
    $display("Starting tb_irrigation_rule");
    #20 rst_n = 1;

    @(posedge clk); soil_moisture <= 16'd250;
    @(posedge clk); soil_moisture <= 16'd280;
    @(posedge clk); soil_moisture <= 16'd650;
    @(posedge clk); soil_moisture <= 16'd500;

    repeat (4) @(posedge clk);

    $display("valve_open = %b", valve_open);
    $finish;
end

endmodule
