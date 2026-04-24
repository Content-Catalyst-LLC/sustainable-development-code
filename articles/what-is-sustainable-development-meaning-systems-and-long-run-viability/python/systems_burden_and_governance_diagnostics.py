from __future__ import annotations

import pandas as pd

INPUT_FILE = "sustainable_development_governance_panel.csv"
OUTPUT_FILE = "systems_burden_and_governance_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "present_deprivation_index",
        "human_wellbeing_support_index",
        "ecological_stress_index",
        "future_burden_transfer_index",
        "institutional_durability_index",
        "systems_interdependence_risk_index",
        "long_run_viability_index",
        "governance_capacity_index",
        "planetary_constraint_exposure_index",
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

    df["systems_burden_score"] = (
        0.22 * df["present_deprivation_index"] +
        0.18 * df["ecological_stress_index"] +
        0.16 * df["future_burden_transfer_index"] +
        0.16 * df["systems_interdependence_risk_index"] +
        0.14 * df["planetary_constraint_exposure_index"] +
        0.14 * (1 - df["human_wellbeing_support_index"])
    ).clip(0, 1)

    df["governance_gap_score"] = (
        0.34 * (1 - df["institutional_durability_index"]) +
        0.33 * (1 - df["governance_capacity_index"]) +
        0.33 * (1 - df["long_run_viability_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Systems-burden and governance diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
