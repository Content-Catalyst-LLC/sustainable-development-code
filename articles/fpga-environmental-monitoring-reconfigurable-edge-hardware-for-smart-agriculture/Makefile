SIM ?= iverilog
VVP ?= vvp

all: test

test: test_moving_average test_irrigation_rule

test_moving_average:
	$(SIM) -o tb_moving_average rtl/moving_average_4.v tb/tb_moving_average_4.v
	$(VVP) tb_moving_average

test_irrigation_rule:
	$(SIM) -o tb_irrigation_rule rtl/irrigation_rule.v tb/tb_irrigation_rule.v
	$(VVP) tb_irrigation_rule

clean:
	rm -f tb_moving_average tb_irrigation_rule
