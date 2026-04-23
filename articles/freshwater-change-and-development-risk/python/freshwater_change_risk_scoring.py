from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "freshwater_change_panel.csv"
OUTPUT_FILE = "freshwater_change_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "streamflow_stress_index",
        "soil_moisture_stress_index",
        "water_quality_burden_index",
        "wastewater_treatment_deficit_index",
        "freshwater_ecosystem_decline_index",
        "food_livelihood_dependence_index",
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

    df["hydrological_stress_score"] = (
        0.22 * df["streamflow_stress_index"] +
        0.20 * df["soil_moisture_stress_index"] +
        0.18 * df["water_quality_burden_index"] +
        0.20 * df["wastewater_treatment_deficit_index"] +
        0.20 * df["freshwater_ecosystem_decline_index"]
    ).clip(lower=0, upper=1)

    df["development_exposure_score"] = (
        0.45 * df["food_livelihood_dependence_index"] +
        0.35 * df["health_sanitation_exposure_index"] +
        0.20 * df["water_quality_burden_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["monitoring_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_freshwater_risk_score"] = (
        0.42 * df["hydrological_stress_score"] +
        0.28 * df["development_exposure_score"] +
        0.15 * df["health_sanitation_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_freshwater_risk_score"] >= 0.80,
            df["constrained_freshwater_risk_score"] >= 0.60,
            df["constrained_freshwater_risk_score"] >= 0.40,
        ],
        [
            "Extreme freshwater-development risk",
            "High freshwater-development risk",
            "Moderate freshwater-development risk",
        ],
        default="Lower freshwater-development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "hydrological_stress_score",
        "development_exposure_score",
        "governance_readiness_score",
        "constrained_freshwater_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_freshwater_risk_score",
            "hydrological_stress_score",
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

    print("Freshwater change and development risk scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
