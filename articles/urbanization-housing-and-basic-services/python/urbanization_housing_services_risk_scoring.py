from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "urbanization_housing_services_panel.csv"
OUTPUT_FILE = "urbanization_housing_services_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "housing_adequacy_index",
        "housing_affordability_stress_index",
        "basic_services_access_index",
        "informality_exclusion_index",
        "mobility_access_index",
        "resilience_weakness_index",
        "justice_exposure_index",
        "governance_capacity_index",
        "urban_transition_readiness_index",
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

    df["urban_capability_score"] = (
        0.28 * df["housing_adequacy_index"] +
        0.26 * df["basic_services_access_index"] +
        0.18 * df["mobility_access_index"] +
        0.14 * df["governance_capacity_index"] +
        0.14 * df["urban_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["urban_fragility_score"] = (
        0.22 * df["housing_affordability_stress_index"] +
        0.22 * df["informality_exclusion_index"] +
        0.20 * df["resilience_weakness_index"] +
        0.18 * df["justice_exposure_index"] +
        0.18 * (1 - df["basic_services_access_index"])
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["urban_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["urban_development_risk_score"] = (
        0.40 * df["urban_fragility_score"] +
        0.25 * (1 - df["urban_capability_score"]) +
        0.20 * df["housing_affordability_stress_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["urban_development_risk_score"] >= 0.80,
            df["urban_development_risk_score"] >= 0.60,
            df["urban_development_risk_score"] >= 0.40,
        ],
        [
            "Extreme urban-development risk",
            "High urban-development risk",
            "Moderate urban-development risk",
        ],
        default="Lower urban-development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "urban_capability_score",
        "urban_fragility_score",
        "governance_readiness_score",
        "urban_development_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "urban_development_risk_score",
            "urban_fragility_score",
            "urban_capability_score",
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

    print("Urbanization, housing, and basic services scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
