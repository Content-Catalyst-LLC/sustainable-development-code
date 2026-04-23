from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "sustainable_finance_project_pipeline.csv"
OUTPUT_FILE = "sustainable_finance_allocation_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load sustainable finance project pipeline data."""
    df = pd.read_csv(path)

    required_columns = [
        "project_id",
        "country",
        "region",
        "sector",
        "project_size_usd",
        "development_need_index",
        "climate_resilience_index",
        "inclusion_index",
        "bankability_index",
        "policy_alignment_index",
        "blended_finance_potential_index",
        "debt_space_constraint_index",
        "implementation_capacity_index",
        "taxonomy_alignment_index",
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
    - development additionality
    - implementation feasibility
    - financeability
    - constrained priority score
    """
    df = df.copy()

    df["development_additionality_score"] = (
        0.35 * df["development_need_index"] +
        0.25 * df["climate_resilience_index"] +
        0.20 * df["inclusion_index"] +
        0.20 * df["policy_alignment_index"]
    ).clip(lower=0, upper=1)

    df["implementation_feasibility_score"] = (
        0.45 * df["implementation_capacity_index"] +
        0.30 * df["bankability_index"] +
        0.25 * df["taxonomy_alignment_index"]
    ).clip(lower=0, upper=1)

    df["financeability_score"] = (
        0.40 * df["bankability_index"] +
        0.25 * df["blended_finance_potential_index"] +
        0.20 * df["taxonomy_alignment_index"] +
        0.15 * (1 - df["debt_space_constraint_index"])
    ).clip(lower=0, upper=1)

    df["constrained_priority_score"] = (
        0.45 * df["development_additionality_score"] +
        0.25 * df["implementation_feasibility_score"] +
        0.20 * df["financeability_score"] +
        0.10 * (1 - df["debt_space_constraint_index"])
    ).clip(lower=0, upper=1)

    df["priority_band"] = np.select(
        [
            df["constrained_priority_score"] >= 0.80,
            df["constrained_priority_score"] >= 0.60,
            df["constrained_priority_score"] >= 0.40,
        ],
        [
            "High priority",
            "Strong priority",
            "Moderate priority",
        ],
        default="Lower priority",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Build a sorted summary table."""
    cols = [
        "project_id",
        "country",
        "region",
        "sector",
        "project_size_usd",
        "development_additionality_score",
        "implementation_feasibility_score",
        "financeability_score",
        "constrained_priority_score",
        "priority_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=["constrained_priority_score", "development_additionality_score", "financeability_score"],
        ascending=[False, False, False],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Sustainable finance allocation scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
