from __future__ import annotations

import pandas as pd

INPUT_FILE = "overshoot_governance_panel.csv"
OUTPUT_FILE = "throughput_pressure_and_delay_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "growth_pressure_index",
        "throughput_pressure_index",
        "resource_depletion_index",
        "waste_absorptive_stress_index",
        "planetary_pressure_index",
        "delay_recognition_risk_index",
        "infrastructure_lockin_index",
        "governance_fragility_index",
        "adaptive_capacity_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    index_columns = [col for col in df.columns if col.endswith("_index")]
    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")
    return df


def compute_scores(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["throughput_stress_score"] = (
        0.25 * df["throughput_pressure_index"] +
        0.25 * df["resource_depletion_index"] +
        0.25 * df["waste_absorptive_stress_index"] +
        0.25 * df["planetary_pressure_index"]
    ).clip(0, 1)

    df["delay_fragility_score"] = (
        0.35 * df["delay_recognition_risk_index"] +
        0.25 * df["infrastructure_lockin_index"] +
        0.20 * df["governance_fragility_index"] +
        0.20 * (1 - df["adaptive_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Throughput-pressure and delay diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
