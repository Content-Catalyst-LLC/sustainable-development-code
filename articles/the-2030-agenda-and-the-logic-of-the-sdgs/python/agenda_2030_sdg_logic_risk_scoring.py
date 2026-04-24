from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "agenda_2030_sdg_logic_panel.csv"
OUTPUT_FILE = "agenda_2030_sdg_logic_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "universality_exposure_index",
        "integration_complexity_index",
        "implementation_capacity_index",
        "means_of_implementation_index",
        "partnership_readiness_index",
        "monitoring_capacity_index",
        "indicator_coverage_index",
        "review_responsiveness_index",
        "policy_fragmentation_index",
        "sdg_alignment_index",
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

    df["agenda_pressure_score"] = (
        0.16 * df["universality_exposure_index"] +
        0.16 * df["integration_complexity_index"] +
        0.14 * (1 - df["implementation_capacity_index"]) +
        0.14 * (1 - df["means_of_implementation_index"]) +
        0.12 * (1 - df["partnership_readiness_index"]) +
        0.12 * (1 - df["monitoring_capacity_index"]) +
        0.08 * (1 - df["indicator_coverage_index"]) +
        0.08 * df["policy_fragmentation_index"]
    ).clip(lower=0, upper=1)

    df["agenda_capacity_score"] = (
        0.28 * df["implementation_capacity_index"] +
        0.22 * df["means_of_implementation_index"] +
        0.18 * df["partnership_readiness_index"] +
        0.16 * df["monitoring_capacity_index"] +
        0.08 * df["indicator_coverage_index"] +
        0.08 * df["review_responsiveness_index"]
    ).clip(lower=0, upper=1)

    df["sdg_governance_risk_score"] = (
        0.50 * df["agenda_pressure_score"] +
        0.30 * (1 - df["agenda_capacity_score"]) +
        0.20 * df["policy_fragmentation_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["sdg_governance_risk_score"] >= 0.80,
            df["sdg_governance_risk_score"] >= 0.60,
            df["sdg_governance_risk_score"] >= 0.40,
        ],
        [
            "Extreme SDG governance risk",
            "High SDG governance risk",
            "Moderate SDG governance risk",
        ],
        default="Lower SDG governance risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "agenda_pressure_score",
        "agenda_capacity_score",
        "sdg_governance_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "sdg_governance_risk_score",
            "agenda_pressure_score",
            "agenda_capacity_score",
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

    print("The 2030 Agenda and SDG logic scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
