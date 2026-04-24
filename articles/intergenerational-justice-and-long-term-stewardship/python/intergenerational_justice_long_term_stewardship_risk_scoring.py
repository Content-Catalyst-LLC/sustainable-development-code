from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "intergenerational_justice_long_term_stewardship_panel.csv"
OUTPUT_FILE = "intergenerational_justice_long_term_stewardship_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "future_burden_transfer_index",
        "ecological_degradation_index",
        "institutional_erosion_index",
        "public_debt_lock_in_index",
        "infrastructure_lock_in_index",
        "climate_risk_transfer_index",
        "future_representation_gap_index",
        "governance_capacity_index",
        "precautionary_planning_index",
        "resilience_preservation_index",
        "justice_exposure_index",
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

    df["future_burden_score"] = (
        0.18 * df["future_burden_transfer_index"] +
        0.16 * df["ecological_degradation_index"] +
        0.14 * df["institutional_erosion_index"] +
        0.12 * df["public_debt_lock_in_index"] +
        0.12 * df["infrastructure_lock_in_index"] +
        0.14 * df["climate_risk_transfer_index"] +
        0.14 * df["future_representation_gap_index"]
    ).clip(lower=0, upper=1)

    df["stewardship_capacity_score"] = (
        0.35 * df["governance_capacity_index"] +
        0.30 * df["precautionary_planning_index"] +
        0.25 * df["resilience_preservation_index"] +
        0.10 * (1 - df["justice_exposure_index"])
    ).clip(lower=0, upper=1)

    df["intergenerational_justice_risk_score"] = (
        0.50 * df["future_burden_score"] +
        0.20 * (1 - df["stewardship_capacity_score"]) +
        0.15 * df["ecological_degradation_index"] +
        0.10 * df["future_representation_gap_index"] +
        0.05 * df["justice_exposure_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["intergenerational_justice_risk_score"] >= 0.80,
            df["intergenerational_justice_risk_score"] >= 0.60,
            df["intergenerational_justice_risk_score"] >= 0.40,
        ],
        [
            "Extreme intergenerational justice risk",
            "High intergenerational justice risk",
            "Moderate intergenerational justice risk",
        ],
        default="Lower intergenerational justice risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "future_burden_score",
        "stewardship_capacity_score",
        "intergenerational_justice_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "intergenerational_justice_risk_score",
            "future_burden_score",
            "stewardship_capacity_score",
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

    print("Intergenerational justice and long-term stewardship scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
