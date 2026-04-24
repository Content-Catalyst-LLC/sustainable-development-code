from __future__ import annotations

import pandas as pd

INPUT_FILE = "systems_problem_governance_panel.csv"
OUTPUT_FILE = "feedback_and_coordination_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "interdependence_intensity_index",
        "feedback_risk_index",
        "delay_exposure_index",
        "path_dependence_index",
        "cross_scale_pressure_index",
        "earth_system_stress_index",
        "governance_fragmentation_index",
        "coordination_capacity_index",
        "institutional_integration_index",
        "leverage_point_capacity_index",
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

    df["interaction_risk_score"] = (
        0.25 * df["interdependence_intensity_index"] +
        0.25 * df["feedback_risk_index"] +
        0.20 * df["delay_exposure_index"] +
        0.15 * df["path_dependence_index"] +
        0.15 * df["cross_scale_pressure_index"]
    ).clip(0, 1)

    df["coordination_gap_score"] = (
        0.35 * df["governance_fragmentation_index"] +
        0.30 * (1 - df["coordination_capacity_index"]) +
        0.20 * (1 - df["institutional_integration_index"]) +
        0.15 * (1 - df["leverage_point_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Feedback and coordination diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
