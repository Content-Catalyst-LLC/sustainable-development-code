from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "local_governance_territorial_panel.csv"
OUTPUT_FILE = "local_governance_territorial_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "city_or_region",
        "country",
        "territory_type",
        "service_reach_index",
        "land_housing_coordination_index",
        "infrastructure_mobility_integration_index",
        "resilience_capacity_index",
        "spatial_justice_index",
        "participatory_local_governance_index",
        "multilevel_alignment_index",
        "data_learning_capacity_index",
        "fragmentation_risk_index",
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

    df["territorial_capacity_score"] = (
        0.18 * df["service_reach_index"] +
        0.16 * df["land_housing_coordination_index"] +
        0.16 * df["infrastructure_mobility_integration_index"] +
        0.16 * df["resilience_capacity_index"] +
        0.14 * df["spatial_justice_index"] +
        0.10 * df["participatory_local_governance_index"] +
        0.10 * df["multilevel_alignment_index"]
    ).clip(lower=0, upper=1)

    df["local_state_learning_score"] = (
        0.40 * df["data_learning_capacity_index"] +
        0.30 * df["multilevel_alignment_index"] +
        0.30 * df["participatory_local_governance_index"]
    ).clip(lower=0, upper=1)

    df["constrained_local_governance_score"] = (
        0.60 * df["territorial_capacity_score"] +
        0.20 * df["local_state_learning_score"] +
        0.10 * df["resilience_capacity_index"] +
        0.10 * (1 - df["fragmentation_risk_index"])
    ).clip(lower=0, upper=1)

    df["territorial_band"] = np.select(
        [
            df["constrained_local_governance_score"] >= 0.80,
            df["constrained_local_governance_score"] >= 0.60,
            df["constrained_local_governance_score"] >= 0.40,
        ],
        [
            "High territorial-governance capacity",
            "Strong territorial-governance capacity",
            "Moderate territorial-governance capacity",
        ],
        default="Constrained territorial-governance capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "city_or_region",
        "country",
        "territory_type",
        "territorial_capacity_score",
        "local_state_learning_score",
        "constrained_local_governance_score",
        "territorial_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_local_governance_score",
            "territorial_capacity_score",
            "local_state_learning_score",
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

    print("Territorial governance and urban capacity scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
