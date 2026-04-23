from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "development_fragility_risk_data.csv"
OUTPUT_FILE = "development_fragility_risk_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load fragility and development risk data from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "shock_exposure_index",
        "climate_risk_index",
        "food_system_stress_index",
        "institutional_capacity_index",
        "infrastructure_resilience_index",
        "social_protection_index",
        "inequality_burden_index",
        "fiscal_space_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure normalized index fields are between 0 and 1."""
    index_columns = [
        "shock_exposure_index",
        "climate_risk_index",
        "food_system_stress_index",
        "institutional_capacity_index",
        "infrastructure_resilience_index",
        "social_protection_index",
        "inequality_burden_index",
        "fiscal_space_index",
    ]

    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_exposure_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute a combined exposure score."""
    df["combined_exposure_score"] = (
        0.40 * df["shock_exposure_index"] +
        0.35 * df["climate_risk_index"] +
        0.25 * df["food_system_stress_index"]
    )
    return df


def compute_resilience_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute a combined resilience score."""
    df["combined_resilience_score"] = (
        0.30 * df["institutional_capacity_index"] +
        0.25 * df["infrastructure_resilience_index"] +
        0.25 * df["social_protection_index"] +
        0.20 * df["fiscal_space_index"]
    )
    return df


def compute_fragility_score(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute fragility as exposure relative to resilience, adjusted for inequality burden.
    Higher fragility means greater developmental vulnerability under stress.
    """
    df["fragility_score"] = (
        0.60 * df["combined_exposure_score"] +
        0.40 * df["inequality_burden_index"]
    ) - (0.50 * df["combined_resilience_score"])

    df["fragility_score"] = df["fragility_score"].clip(lower=0)

    df["fragility_band"] = np.select(
        [
            df["fragility_score"] >= 0.65,
            df["fragility_score"] >= 0.45,
            df["fragility_score"] >= 0.25,
        ],
        [
            "Severe fragility",
            "Elevated fragility",
            "Moderate fragility",
        ],
        default="Lower fragility",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Build a compact summary table sorted by fragility."""
    summary_columns = [
        "country",
        "region",
        "combined_exposure_score",
        "combined_resilience_score",
        "inequality_burden_index",
        "fragility_score",
        "fragility_band",
    ]

    summary = df[summary_columns].copy()
    summary = summary.sort_values(
        by=["fragility_score", "combined_exposure_score"],
        ascending=[False, False],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    df = compute_exposure_score(df)
    df = compute_resilience_score(df)
    df = compute_fragility_score(df)

    summary = build_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Development fragility risk scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
