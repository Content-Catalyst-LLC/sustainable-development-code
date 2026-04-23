from __future__ import annotations

import pandas as pd

INPUT_FILE = "air_quality_risk_panel.csv"
OUTPUT_FILE = "inequality_governance_and_monitoring_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "ambient_pm25_index",
        "household_energy_exposure_index",
        "exposure_inequality_index",
        "mitigation_capacity_index",
        "monitoring_readiness_index",
        "health_sensitivity_index",
        "industrial_source_pressure_index",
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

    df["inequality_burden_score"] = (
        0.35 * df["exposure_inequality_index"] +
        0.25 * df["health_sensitivity_index"] +
        0.20 * df["household_energy_exposure_index"] +
        0.20 * df["ambient_pm25_index"]
    ).clip(0, 1)

    df["governance_gap_score"] = (
        0.40 * (1 - df["mitigation_capacity_index"]) +
        0.35 * (1 - df["monitoring_readiness_index"]) +
        0.25 * df["industrial_source_pressure_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Inequality, governance, and monitoring diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
