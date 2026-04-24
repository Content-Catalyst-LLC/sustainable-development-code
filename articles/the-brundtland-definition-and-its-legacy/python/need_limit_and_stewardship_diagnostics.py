from __future__ import annotations

import pandas as pd

INPUT_FILE = "brundtland_governance_panel.csv"
OUTPUT_FILE = "need_limit_and_stewardship_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "present_need_pressure_index",
        "poverty_reduction_support_index",
        "ecological_degradation_index",
        "future_burden_transfer_index",
        "institutional_durability_index",
        "intergenerational_stewardship_index",
        "absorptive_capacity_stress_index",
        "technology_organisation_constraint_index",
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

    df["need_limit_gap_score"] = (
        0.25 * df["present_need_pressure_index"] +
        0.20 * (1 - df["poverty_reduction_support_index"]) +
        0.20 * df["ecological_degradation_index"] +
        0.20 * df["absorptive_capacity_stress_index"] +
        0.15 * df["technology_organisation_constraint_index"]
    ).clip(0, 1)

    df["stewardship_gap_score"] = (
        0.35 * df["future_burden_transfer_index"] +
        0.25 * (1 - df["institutional_durability_index"]) +
        0.25 * (1 - df["intergenerational_stewardship_index"]) +
        0.15 * df["ecological_degradation_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Need-limit and stewardship diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
