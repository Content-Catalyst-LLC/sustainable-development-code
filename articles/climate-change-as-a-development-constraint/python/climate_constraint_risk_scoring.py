from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "climate_constraint_panel.csv"
OUTPUT_FILE = "climate_constraint_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "heat_stress_index",
        "hydrological_disruption_index",
        "food_livelihood_exposure_index",
        "health_burden_index",
        "infrastructure_vulnerability_index",
        "justice_exposure_index",
        "governance_capacity_index",
        "resilience_readiness_index",
        "disaster_recurrence_index",
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

    df["climate_stress_score"] = (
        0.20 * df["heat_stress_index"] +
        0.18 * df["hydrological_disruption_index"] +
        0.18 * df["disaster_recurrence_index"] +
        0.22 * df["infrastructure_vulnerability_index"] +
        0.22 * df["health_burden_index"]
    ).clip(lower=0, upper=1)

    df["development_exposure_score"] = (
        0.40 * df["food_livelihood_exposure_index"] +
        0.25 * df["justice_exposure_index"] +
        0.20 * df["health_burden_index"] +
        0.15 * df["infrastructure_vulnerability_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["resilience_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_climate_development_score"] = (
        0.42 * df["climate_stress_score"] +
        0.28 * df["development_exposure_score"] +
        0.15 * df["justice_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_climate_development_score"] >= 0.80,
            df["constrained_climate_development_score"] >= 0.60,
            df["constrained_climate_development_score"] >= 0.40,
        ],
        [
            "Extreme climate-development risk",
            "High climate-development risk",
            "Moderate climate-development risk",
        ],
        default="Lower climate-development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "climate_stress_score",
        "development_exposure_score",
        "governance_readiness_score",
        "constrained_climate_development_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_climate_development_score",
            "climate_stress_score",
            "development_exposure_score",
        ],
        ascending=[False, False, False],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Climate constraint and development risk scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
