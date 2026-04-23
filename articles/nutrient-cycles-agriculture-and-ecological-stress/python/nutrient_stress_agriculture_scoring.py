from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "nutrient_cycles_agriculture_panel.csv"
OUTPUT_FILE = "nutrient_cycles_agriculture_stress_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "nitrogen_surplus_index",
        "phosphorus_surplus_index",
        "runoff_leakage_index",
        "eutrophication_exposure_index",
        "soil_balance_stress_index",
        "food_system_dependence_index",
        "governance_capacity_index",
        "monitoring_readiness_index",
        "water_quality_burden_index",
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

    df["biogeochemical_stress_score"] = (
        0.24 * df["nitrogen_surplus_index"] +
        0.22 * df["phosphorus_surplus_index"] +
        0.20 * df["runoff_leakage_index"] +
        0.18 * df["soil_balance_stress_index"] +
        0.16 * df["water_quality_burden_index"]
    ).clip(lower=0, upper=1)

    df["development_dependence_score"] = (
        0.50 * df["food_system_dependence_index"] +
        0.30 * df["eutrophication_exposure_index"] +
        0.20 * df["water_quality_burden_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["monitoring_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_nutrient_stress_score"] = (
        0.42 * df["biogeochemical_stress_score"] +
        0.28 * df["development_dependence_score"] +
        0.15 * df["eutrophication_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_nutrient_stress_score"] >= 0.80,
            df["constrained_nutrient_stress_score"] >= 0.60,
            df["constrained_nutrient_stress_score"] >= 0.40,
        ],
        [
            "Extreme nutrient-development stress",
            "High nutrient-development stress",
            "Moderate nutrient-development stress",
        ],
        default="Lower nutrient-development stress",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "biogeochemical_stress_score",
        "development_dependence_score",
        "governance_readiness_score",
        "constrained_nutrient_stress_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_nutrient_stress_score",
            "biogeochemical_stress_score",
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

    print("Nutrient stress and agricultural development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
