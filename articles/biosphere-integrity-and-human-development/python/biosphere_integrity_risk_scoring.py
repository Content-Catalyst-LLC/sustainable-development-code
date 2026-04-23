from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "biosphere_integrity_panel.csv"
OUTPUT_FILE = "biosphere_integrity_human_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "ecosystem_degradation_index",
        "fragmentation_risk_index",
        "ecological_service_erosion_index",
        "food_water_health_dependence_index",
        "livelihood_ecological_dependence_index",
        "justice_exposure_index",
        "governance_capacity_index",
        "restoration_readiness_index",
        "biosphere_function_loss_index",
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

    df["biosphere_stress_score"] = (
        0.24 * df["ecosystem_degradation_index"] +
        0.18 * df["fragmentation_risk_index"] +
        0.20 * df["ecological_service_erosion_index"] +
        0.20 * df["biosphere_function_loss_index"] +
        0.18 * df["justice_exposure_index"]
    ).clip(lower=0, upper=1)

    df["development_dependence_score"] = (
        0.50 * df["food_water_health_dependence_index"] +
        0.30 * df["livelihood_ecological_dependence_index"] +
        0.20 * df["ecological_service_erosion_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["restoration_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_biosphere_development_score"] = (
        0.42 * df["biosphere_stress_score"] +
        0.28 * df["development_dependence_score"] +
        0.15 * df["justice_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_biosphere_development_score"] >= 0.80,
            df["constrained_biosphere_development_score"] >= 0.60,
            df["constrained_biosphere_development_score"] >= 0.40,
        ],
        [
            "Extreme biosphere-development risk",
            "High biosphere-development risk",
            "Moderate biosphere-development risk",
        ],
        default="Lower biosphere-development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "biosphere_stress_score",
        "development_dependence_score",
        "governance_readiness_score",
        "constrained_biosphere_development_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_biosphere_development_score",
            "biosphere_stress_score",
            "development_dependence_score",
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

    print("Biosphere integrity and human development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
