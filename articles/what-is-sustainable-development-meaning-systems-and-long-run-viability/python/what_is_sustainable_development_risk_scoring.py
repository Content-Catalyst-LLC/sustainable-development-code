from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "what_is_sustainable_development_panel.csv"
OUTPUT_FILE = "what_is_sustainable_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "present_deprivation_index",
        "human_wellbeing_support_index",
        "ecological_stress_index",
        "future_burden_transfer_index",
        "institutional_durability_index",
        "systems_interdependence_risk_index",
        "long_run_viability_index",
        "governance_capacity_index",
        "planetary_constraint_exposure_index",
        "development_alignment_index",
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

    df["sustainable_development_pressure_score"] = (
        0.16 * df["present_deprivation_index"] +
        0.14 * (1 - df["human_wellbeing_support_index"]) +
        0.14 * df["ecological_stress_index"] +
        0.12 * df["future_burden_transfer_index"] +
        0.10 * (1 - df["institutional_durability_index"]) +
        0.10 * df["systems_interdependence_risk_index"] +
        0.12 * (1 - df["long_run_viability_index"]) +
        0.12 * df["planetary_constraint_exposure_index"]
    ).clip(lower=0, upper=1)

    df["sustainable_development_capacity_score"] = (
        0.22 * df["human_wellbeing_support_index"] +
        0.20 * df["institutional_durability_index"] +
        0.18 * df["long_run_viability_index"] +
        0.18 * df["governance_capacity_index"] +
        0.12 * (1 - df["planetary_constraint_exposure_index"]) +
        0.10 * df["development_alignment_index"]
    ).clip(lower=0, upper=1)

    df["sustainable_development_risk_score"] = (
        0.50 * df["sustainable_development_pressure_score"] +
        0.30 * (1 - df["sustainable_development_capacity_score"]) +
        0.20 * df["future_burden_transfer_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["sustainable_development_risk_score"] >= 0.80,
            df["sustainable_development_risk_score"] >= 0.60,
            df["sustainable_development_risk_score"] >= 0.40,
        ],
        [
            "Extreme sustainable development risk",
            "High sustainable development risk",
            "Moderate sustainable development risk",
        ],
        default="Lower sustainable development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "sustainable_development_pressure_score",
        "sustainable_development_capacity_score",
        "sustainable_development_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "sustainable_development_risk_score",
            "sustainable_development_pressure_score",
            "sustainable_development_capacity_score",
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

    print("What is sustainable development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
