from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "tradeoffs_synergies_policy_coherence_panel.csv"
OUTPUT_FILE = "tradeoffs_synergies_policy_coherence_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "tradeoff_intensity_index",
        "synergy_realization_index",
        "sectoral_spillover_index",
        "transboundary_spillover_index",
        "intergenerational_spillover_index",
        "coordination_capacity_index",
        "impact_assessment_index",
        "monitoring_review_index",
        "sequencing_capacity_index",
        "governance_fragmentation_index",
        "policy_alignment_index",
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

    df["policy_interaction_pressure_score"] = (
        0.20 * df["tradeoff_intensity_index"] +
        0.16 * df["sectoral_spillover_index"] +
        0.14 * df["transboundary_spillover_index"] +
        0.14 * df["intergenerational_spillover_index"] +
        0.18 * df["governance_fragmentation_index"] +
        0.18 * (1 - df["policy_alignment_index"])
    ).clip(lower=0, upper=1)

    df["coherence_capacity_score"] = (
        0.28 * df["coordination_capacity_index"] +
        0.20 * df["impact_assessment_index"] +
        0.18 * df["monitoring_review_index"] +
        0.18 * df["sequencing_capacity_index"] +
        0.16 * df["synergy_realization_index"]
    ).clip(lower=0, upper=1)

    df["policy_coherence_risk_score"] = (
        0.50 * df["policy_interaction_pressure_score"] +
        0.25 * (1 - df["coherence_capacity_score"]) +
        0.15 * df["governance_fragmentation_index"] +
        0.10 * (1 - df["policy_alignment_index"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["policy_coherence_risk_score"] >= 0.80,
            df["policy_coherence_risk_score"] >= 0.60,
            df["policy_coherence_risk_score"] >= 0.40,
        ],
        [
            "Extreme policy coherence risk",
            "High policy coherence risk",
            "Moderate policy coherence risk",
        ],
        default="Lower policy coherence risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "policy_interaction_pressure_score",
        "coherence_capacity_score",
        "policy_coherence_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "policy_coherence_risk_score",
            "policy_interaction_pressure_score",
            "coherence_capacity_score",
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

    print("Trade-offs, synergies, and policy coherence scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
