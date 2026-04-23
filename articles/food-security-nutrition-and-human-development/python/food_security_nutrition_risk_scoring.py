from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "food_security_nutrition_panel.csv"
OUTPUT_FILE = "food_security_nutrition_human_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "food_access_index",
        "healthy_diet_affordability_stress_index",
        "nutrition_quality_index",
        "price_volatility_index",
        "child_maternal_risk_index",
        "food_system_fragility_index",
        "poverty_exposure_index",
        "governance_capacity_index",
        "nutrition_transition_readiness_index",
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

    df["nutrition_capability_score"] = (
        0.30 * df["food_access_index"] +
        0.26 * df["nutrition_quality_index"] +
        0.16 * df["governance_capacity_index"] +
        0.14 * df["nutrition_transition_readiness_index"] +
        0.14 * (1 - df["healthy_diet_affordability_stress_index"])
    ).clip(lower=0, upper=1)

    df["food_fragility_score"] = (
        0.22 * df["healthy_diet_affordability_stress_index"] +
        0.18 * df["price_volatility_index"] +
        0.20 * df["food_system_fragility_index"] +
        0.20 * df["poverty_exposure_index"] +
        0.20 * df["child_maternal_risk_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["nutrition_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["food_development_risk_score"] = (
        0.40 * df["food_fragility_score"] +
        0.25 * (1 - df["nutrition_capability_score"]) +
        0.20 * df["healthy_diet_affordability_stress_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["food_development_risk_score"] >= 0.80,
            df["food_development_risk_score"] >= 0.60,
            df["food_development_risk_score"] >= 0.40,
        ],
        [
            "Extreme food-development risk",
            "High food-development risk",
            "Moderate food-development risk",
        ],
        default="Lower food-development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "nutrition_capability_score",
        "food_fragility_score",
        "governance_readiness_score",
        "food_development_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "food_development_risk_score",
            "food_fragility_score",
            "nutrition_capability_score",
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

    print("Food security, nutrition, and human development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
