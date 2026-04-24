from __future__ import annotations

import math
from dataclasses import dataclass

@dataclass
class FixedPointFormat:
    total_bits: int
    frac_bits: int

    @property
    def lsb(self) -> float:
        return 2.0 ** (-self.frac_bits)

    @property
    def max_value(self) -> float:
        int_bits = self.total_bits - self.frac_bits - 1
        return (2 ** int_bits) - self.lsb

    @property
    def min_value(self) -> float:
        int_bits = self.total_bits - self.frac_bits - 1
        return -(2 ** int_bits)

def quantize(value: float, fmt: FixedPointFormat) -> float:
    clipped = min(max(value, fmt.min_value), fmt.max_value)
    scaled = round(clipped / fmt.lsb)
    return scaled * fmt.lsb

def report(values: list[float], fmt: FixedPointFormat) -> None:
    print(f"Format Q{fmt.total_bits - fmt.frac_bits - 1}.{fmt.frac_bits}")
    print(f"LSB = {fmt.lsb}")
    for v in values:
        q = quantize(v, fmt)
        err = q - v
        print(f"value={v: .6f} quantized={q: .6f} error={err: .6f}")

if __name__ == "__main__":
    fmt = FixedPointFormat(total_bits=16, frac_bits=8)
    report([0.1, 1.234, -2.75, 15.9, 120.456], fmt)
