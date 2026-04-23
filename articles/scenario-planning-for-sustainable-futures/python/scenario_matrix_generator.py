from __future__ import annotations

import itertools
import pandas as pd

OUTPUT_FILE = "scenario_matrix.csv"

DRIVERS = {
    "climate_path": ["moderate", "severe"],
    "trade_order": ["cooperative", "fragmented"],
    "technology_diffusion": ["broad", "concentrated"],
    "governance_capacity": ["strong", "stressed"],
}


def build_scenario_matrix(drivers: dict[str, list[str]]) -> pd.DataFrame:
    """Generate all combinations of key scenario drivers."""
    keys = list(drivers.keys())
    values = [drivers[key] for key in keys]
    rows = []

    for combination in itertools.product(*values):
        row = dict(zip(keys, combination))
        row["scenario_name"] = " / ".join(combination)
        rows.append(row)

    return pd.DataFrame(rows)


def main() -> None:
    df = build_scenario_matrix(DRIVERS)
    df.to_csv(OUTPUT_FILE, index=False)
    print("Scenario matrix created successfully.")
    print(df.to_string(index=False))


if __name__ == "__main__":
    main()
