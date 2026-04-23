from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "infrastructure_access_capability_panel.csv"
OUTPUT_FILE = "infrastructure_access_and_capability_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load infrastructure access and service-capability data."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "territory_type",
        "transport_access_index",
        "water_access_index",
        "sanitation_access_index",
        "electricity_access_index",
        "digital_connectivity_index",
        "public_service_reach_index",
        "reliability_index",
        "maintenance_capacity_index",
        "territorial_equity_index",
        "climate_resilience_index",
        "lock_in_risk_index",
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
    - infrastructure access score
    - infrastructure capability score
    - resilience score
    - constrained development-enabling infrastructure score
    """
    df = df.copy()

    df["infrastructure_access_score"] = (
        0.18 * df["transport_access_index"] +
        0.18 * df["water_access_index"] +
        0.14 * df["sanitation_access_index"] +
        0.18 * df["electricity_access_index"] +
        0.14 * df["digital_connectivity_index"] +
        0.18 * df["territorial_equity_index"]
    ).clip(lower=0, upper=1)

    df["infrastructure_capability_score"] = (
        0.30 * df["public_service_reach_index"] +
        0.25 * df["reliability_index"] +
        0.25 * df["maintenance_capacity_index"] +
        0.20 * df["infrastructure_access_score"]
    ).clip(lower=0, upper=1)

    df["resilience_score"] = (
        0.40 * df["climate_resilience_index"] +
        0.30 * df["reliability_index"] +
        0.30 * df["maintenance_capacity_index"]
    ).clip(lower=0, upper=1)

    df["constrained_development_enabling_infrastructure_score"] = (
        0.35 * df["infrastructure_access_score"] +
        0.30 * df["infrastructure_capability_score"] +
        0.25 * df["resilience_score"] +
        0.10 * (1 - df["lock_in_risk_index"])
    ).clip(lower=0, upper=1)

    df["infrastructure_band"] = np.select(
        [
            df["constrained_development_enabling_infrastructure_score"] >= 0.80,
            df["constrained_development_enabling_infrastructure_score"] >= 0.60,
            df["constrained_development_enabling_infrastructure_score"] >= 0.40,
        ],
        [
            "High infrastructure capacity",
            "Strong infrastructure capacity",
            "Moderate infrastructure capacity",
        ],
        default="Constrained infrastructure capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "territory_type",
        "infrastructure_access_score",
        "infrastructure_capability_score",
        "resilience_score",
        "constrained_development_enabling_infrastructure_score",
        "infrastructure_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_development_enabling_infrastructure_score",
            "infrastructure_access_score",
            "infrastructure_capability_score",
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

    print("Infrastructure access and capability scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
