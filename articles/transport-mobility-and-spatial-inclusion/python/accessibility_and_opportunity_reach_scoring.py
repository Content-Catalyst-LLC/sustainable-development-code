from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "mobility_accessibility_panel.csv"
OUTPUT_FILE = "accessibility_and_opportunity_reach_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load accessibility and mobility data."""
    df = pd.read_csv(path)

    required_columns = [
        "city_region",
        "country",
        "territory_type",
        "public_transport_coverage_index",
        "jobs_access_index",
        "education_access_index",
        "healthcare_access_index",
        "fare_affordability_index",
        "travel_time_burden_index",
        "safety_index",
        "walkability_index",
        "universal_access_index",
        "multimodal_integration_index",
        "car_dependence_risk_index",
        "climate_alignment_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure all *_index columns are bounded in [0, 1]."""
    index_columns = [col for col in df.columns if col.endswith("_index")]
    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")
    return df


def compute_scores(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute:
    - accessibility score
    - everyday mobility inclusion score
    - sustainable mobility alignment score
    - constrained spatial inclusion score
    """
    df = df.copy()

    df["accessibility_score"] = (
        0.20 * df["jobs_access_index"] +
        0.20 * df["education_access_index"] +
        0.20 * df["healthcare_access_index"] +
        0.15 * df["public_transport_coverage_index"] +
        0.10 * df["walkability_index"] +
        0.15 * df["multimodal_integration_index"]
    ).clip(lower=0, upper=1)

    df["everyday_mobility_inclusion_score"] = (
        0.20 * df["fare_affordability_index"] +
        0.20 * (1 - df["travel_time_burden_index"]) +
        0.20 * df["safety_index"] +
        0.20 * df["universal_access_index"] +
        0.20 * df["public_transport_coverage_index"]
    ).clip(lower=0, upper=1)

    df["sustainable_mobility_alignment_score"] = (
        0.30 * df["climate_alignment_index"] +
        0.25 * df["walkability_index"] +
        0.20 * df["multimodal_integration_index"] +
        0.25 * (1 - df["car_dependence_risk_index"])
    ).clip(lower=0, upper=1)

    df["constrained_spatial_inclusion_score"] = (
        0.40 * df["accessibility_score"] +
        0.30 * df["everyday_mobility_inclusion_score"] +
        0.20 * df["sustainable_mobility_alignment_score"] +
        0.10 * (1 - df["car_dependence_risk_index"])
    ).clip(lower=0, upper=1)

    df["inclusion_band"] = np.select(
        [
            df["constrained_spatial_inclusion_score"] >= 0.80,
            df["constrained_spatial_inclusion_score"] >= 0.60,
            df["constrained_spatial_inclusion_score"] >= 0.40,
        ],
        [
            "High spatial inclusion",
            "Strong spatial inclusion",
            "Moderate spatial inclusion",
        ],
        default="Constrained spatial inclusion",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "city_region",
        "country",
        "territory_type",
        "accessibility_score",
        "everyday_mobility_inclusion_score",
        "sustainable_mobility_alignment_score",
        "constrained_spatial_inclusion_score",
        "inclusion_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_spatial_inclusion_score",
            "accessibility_score",
            "everyday_mobility_inclusion_score",
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

    print("Accessibility and opportunity-reach scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
