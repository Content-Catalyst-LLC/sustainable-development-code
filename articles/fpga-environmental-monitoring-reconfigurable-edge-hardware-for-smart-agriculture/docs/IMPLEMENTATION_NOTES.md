# Implementation Notes

## Core questions
1. Which agricultural sensing workloads justify FPGA acceleration?
2. How much backhaul reduction is gained by edge preprocessing?
3. Which local control loops must remain available under connectivity loss?
4. When is Linux + FPGA preferable to MCU-only or FPGA-only designs?
5. What verification evidence is required before field deployment?

## Validation stack
- RTL simulation
- integration testing
- hardware-in-the-loop replay
- field acceptance against calibrated instruments

## Numeric design
Prefer fixed-point unless floating-point is demonstrably necessary.
Document:
- word length
- fractional precision
- saturation behavior
- acceptable error bounds

## Deployment doctrine
Use FPGA only when concurrency, determinism, or edge reduction justify it.
