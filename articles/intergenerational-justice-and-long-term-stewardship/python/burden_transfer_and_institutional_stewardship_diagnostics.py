from __future__ import annotations

import pandas as pd

INPUT_FILE = "intergenerational_stewardship_governance_panel.csv"
OUTPUT_FILE = "burden_transfer_and_institutional_stewardship_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "future_burden_transfer_index",
        "ecological_degradation_index",
        "institutional_erosion_index",
        "public_debt_lock_in_index",
        "infrastructure_lock_in_index",
        "future_representation_gap_index",
        "governance_capacity_index",
        "precautionary_planning_index",
        "resilience_preservation_index",
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

    df["future_transfer_pressure_score"] = (
        0.24 * df["future_burden_transfer_index"] +
        0.18 * df["public_debt_lock_in_index"] +
        0.18 * df["infrastructure_lock_in_index"] +
        0.20 * df["ecological_degradation_index"] +
        0.20 * df["future_representation_gap_index"]
    ).clip(0, 1)

    df["institutional_stewardship_gap_score"] = (
        0.40 * (1 - df["governance_capacity_index"]) +
        0.30 * (1 - df["precautionary_planning_index"]) +
        0.30 * (1 - df["resilience_preservation_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Burden-transfer and institutional-stewardship diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
