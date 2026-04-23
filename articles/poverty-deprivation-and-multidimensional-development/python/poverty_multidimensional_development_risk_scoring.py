from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "poverty_multidimensional_development_panel.csv"
OUTPUT_FILE = "poverty_multidimensional_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "income_poverty_index",
        "housing_deprivation_index",
        "sanitation_deprivation_index",
        "electricity_cooking_fuel_deprivation_index",
        "nutrition_deprivation_index",
        "learning_deprivation_index",
        "climate_exposure_index",
        "child_vulnerability_index",
        "public_goods_access_index",
        "governance_capacity_index",
        "poverty_transition_readiness_index",
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

    df["multidimensional_deprivation_score"] = (
        0.12 * df["income_poverty_index"] +
        0.14 * df["housing_deprivation_index"] +
        0.14 * df["sanitation_deprivation_index"] +
        0.14 * df["electricity_cooking_fuel_deprivation_index"] +
        0.14 * df["nutrition_deprivation_index"] +
        0.14 * df["learning_deprivation_index"] +
        0.09 * df["climate_exposure_index"] +
        0.09 * df["child_vulnerability_index"]
    ).clip(lower=0, upper=1)

    df["capability_support_score"] = (
        0.35 * df["public_goods_access_index"] +
        0.35 * df["governance_capacity_index"] +
        0.30 * df["poverty_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["poverty_reproduction_risk_score"] = (
        0.45 * df["multidimensional_deprivation_score"] +
        0.20 * df["climate_exposure_index"] +
        0.15 * df["child_vulnerability_index"] +
        0.20 * (1 - df["capability_support_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["poverty_reproduction_risk_score"] >= 0.80,
            df["poverty_reproduction_risk_score"] >= 0.60,
            df["poverty_reproduction_risk_score"] >= 0.40,
        ],
        [
            "Extreme multidimensional poverty risk",
            "High multidimensional poverty risk",
            "Moderate multidimensional poverty risk",
        ],
        default="Lower multidimensional poverty risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "multidimensional_deprivation_score",
        "capability_support_score",
        "poverty_reproduction_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "poverty_reproduction_risk_score",
            "multidimensional_deprivation_score",
            "capability_support_score",
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

    print("Poverty, deprivation, and multidimensional development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
