from __future__ import annotations

import pandas as pd

INPUT_FILE = "freshwater_governance_panel.csv"
OUTPUT_FILE = "monitoring_governance_and_water_burden_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "streamflow_stress_index",
        "water_quality_burden_index",
        "wastewater_treatment_deficit_index",
        "freshwater_ecosystem_decline_index",
        "health_sanitation_exposure_index",
        "governance_capacity_index",
        "monitoring_readiness_index",
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

    df["governance_gap_score"] = (
        0.35 * (1 - df["governance_capacity_index"]) +
        0.30 * (1 - df["monitoring_readiness_index"]) +
        0.20 * df["wastewater_treatment_deficit_index"] +
        0.15 * df["water_quality_burden_index"]
    ).clip(0, 1)

    df["water_system_burden_score"] = (
        0.25 * df["streamflow_stress_index"] +
        0.25 * df["freshwater_ecosystem_decline_index"] +
        0.25 * df["health_sanitation_exposure_index"] +
        0.25 * df["water_quality_burden_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Monitoring, governance, and water-system burden diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
