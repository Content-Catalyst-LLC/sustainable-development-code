from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "industrial_transformation_panel.csv"
OUTPUT_FILE = "structural_transformation_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load country-sector industrial transformation data."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "sector",
        "manufacturing_value_added_index",
        "services_productivity_index",
        "export_complexity_index",
        "technology_upgrading_index",
        "skills_depth_index",
        "infrastructure_quality_index",
        "supplier_ecosystem_index",
        "green_transition_readiness_index",
        "regional_inclusion_index",
        "institutional_coordination_index",
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
    - productive capability score
    - structural transformation score
    - green industrial alignment score
    - constrained transition score
    """
    df = df.copy()

    df["productive_capability_score"] = (
        0.20 * df["technology_upgrading_index"] +
        0.18 * df["skills_depth_index"] +
        0.17 * df["supplier_ecosystem_index"] +
        0.15 * df["infrastructure_quality_index"] +
        0.15 * df["institutional_coordination_index"] +
        0.15 * df["export_complexity_index"]
    ).clip(lower=0, upper=1)

    df["structural_transformation_score"] = (
        0.22 * df["manufacturing_value_added_index"] +
        0.15 * df["services_productivity_index"] +
        0.18 * df["productive_capability_score"] +
        0.15 * df["regional_inclusion_index"] +
        0.15 * df["supplier_ecosystem_index"] +
        0.15 * df["technology_upgrading_index"]
    ).clip(lower=0, upper=1)

    df["green_industrial_alignment_score"] = (
        0.35 * df["green_transition_readiness_index"] +
        0.25 * df["technology_upgrading_index"] +
        0.20 * df["infrastructure_quality_index"] +
        0.20 * df["institutional_coordination_index"]
    ).clip(lower=0, upper=1)

    df["constrained_transition_score"] = (
        0.45 * df["structural_transformation_score"] +
        0.25 * df["productive_capability_score"] +
        0.20 * df["green_industrial_alignment_score"] +
        0.10 * (1 - df["lock_in_risk_index"])
    ).clip(lower=0, upper=1)

    df["transition_band"] = np.select(
        [
            df["constrained_transition_score"] >= 0.80,
            df["constrained_transition_score"] >= 0.60,
            df["constrained_transition_score"] >= 0.40,
        ],
        [
            "High transition capacity",
            "Strong transition capacity",
            "Moderate transition capacity",
        ],
        default="Constrained transition capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "sector",
        "productive_capability_score",
        "structural_transformation_score",
        "green_industrial_alignment_score",
        "constrained_transition_score",
        "transition_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_transition_score",
            "structural_transformation_score",
            "productive_capability_score",
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

    print("Structural transformation scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
