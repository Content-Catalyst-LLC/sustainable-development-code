from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "aerosols_air_quality_panel.csv"
OUTPUT_FILE = "aerosols_air_quality_public_health_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "ambient_pm25_index",
        "ambient_pm10_index",
        "household_energy_exposure_index",
        "transport_emissions_pressure_index",
        "industrial_source_pressure_index",
        "health_sensitivity_index",
        "mitigation_capacity_index",
        "exposure_inequality_index",
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

    df["exposure_burden_score"] = (
        0.28 * df["ambient_pm25_index"] +
        0.18 * df["ambient_pm10_index"] +
        0.18 * df["household_energy_exposure_index"] +
        0.18 * df["transport_emissions_pressure_index"] +
        0.18 * df["industrial_source_pressure_index"]
    ).clip(lower=0, upper=1)

    df["public_health_vulnerability_score"] = (
        0.45 * df["health_sensitivity_index"] +
        0.35 * df["exposure_inequality_index"] +
        0.20 * (1 - df["mitigation_capacity_index"])
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["mitigation_capacity_index"] +
        0.45 * df["monitoring_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_aerosol_burden_score"] = (
        0.45 * df["exposure_burden_score"] +
        0.30 * df["public_health_vulnerability_score"] +
        0.15 * df["exposure_inequality_index"] +
        0.10 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["air_quality_band"] = np.select(
        [
            df["constrained_aerosol_burden_score"] >= 0.80,
            df["constrained_aerosol_burden_score"] >= 0.60,
            df["constrained_aerosol_burden_score"] >= 0.40,
        ],
        [
            "Extreme aerosol-health burden",
            "High aerosol-health burden",
            "Moderate aerosol-health burden",
        ],
        default="Lower aerosol-health burden",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "exposure_burden_score",
        "public_health_vulnerability_score",
        "governance_readiness_score",
        "constrained_aerosol_burden_score",
        "air_quality_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_aerosol_burden_score",
            "exposure_burden_score",
            "public_health_vulnerability_score",
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

    print("Aerosol exposure and public-health burden scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
