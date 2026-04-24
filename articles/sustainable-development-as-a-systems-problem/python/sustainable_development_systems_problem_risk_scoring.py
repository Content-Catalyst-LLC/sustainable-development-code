from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "sustainable_development_systems_problem_panel.csv"
OUTPUT_FILE = "sustainable_development_systems_problem_scores.csv"


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

    df["systems_pressure_score"] = (
        0.16 * df["interdependence_intensity_index"] +
        0.16 * df["feedback_risk_index"] +
        0.14 * df["delay_exposure_index"] +
        0.14 * df["path_dependence_index"] +
        0.14 * df["cross_scale_pressure_index"] +
        0.14 * df["earth_system_stress_index"] +
        0.12 * df["governance_fragmentation_index"]
    ).clip(lower=0, upper=1)

    df["systems_capacity_score"] = (
        0.36 * df["coordination_capacity_index"] +
        0.34 * df["institutional_integration_index"] +
        0.30 * df["leverage_point_capacity_index"]
    ).clip(lower=0, upper=1)

    df["systems_fragility_score"] = (
        0.55 * df["systems_pressure_score"] +
        0.25 * (1 - df["systems_capacity_score"]) +
        0.20 * df["governance_fragmentation_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["systems_fragility_score"] >= 0.80,
            df["systems_fragility_score"] >= 0.60,
            df["systems_fragility_score"] >= 0.40,
        ],
        [
            "Extreme systems fragility",
            "High systems fragility",
            "Moderate systems fragility",
        ],
        default="Lower systems fragility",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "systems_pressure_score",
        "systems_capacity_score",
        "systems_fragility_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "systems_fragility_score",
            "systems_pressure_score",
            "systems_capacity_score",
        ],
        ascending=[False, False, True],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Sustainable development as a systems problem scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
