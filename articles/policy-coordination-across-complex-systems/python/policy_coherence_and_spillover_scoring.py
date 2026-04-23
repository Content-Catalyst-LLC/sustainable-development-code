from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "policy_coherence_panel.csv"
OUTPUT_FILE = "policy_coherence_and_spillover_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load policy coherence and cross-sector interaction data."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "policy_domain",
        "cross_sector_alignment_index",
        "spillover_management_index",
        "tradeoff_visibility_index",
        "synergy_capture_index",
        "implementation_alignment_index",
        "multilevel_coordination_index",
        "data_visibility_index",
        "institutional_learning_index",
        "resilience_integration_index",
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
    - coherence score
    - adaptive governance score
    - coordinated transition score
    - constrained systemic-governance score
    """
    df = df.copy()

    df["policy_coherence_score"] = (
        0.25 * df["cross_sector_alignment_index"] +
        0.20 * df["spillover_management_index"] +
        0.15 * df["tradeoff_visibility_index"] +
        0.15 * df["synergy_capture_index"] +
        0.15 * df["implementation_alignment_index"] +
        0.10 * df["multilevel_coordination_index"]
    ).clip(lower=0, upper=1)

    df["adaptive_governance_score"] = (
        0.25 * df["data_visibility_index"] +
        0.25 * df["institutional_learning_index"] +
        0.20 * df["spillover_management_index"] +
        0.15 * df["multilevel_coordination_index"] +
        0.15 * df["implementation_alignment_index"]
    ).clip(lower=0, upper=1)

    df["coordinated_transition_score"] = (
        0.35 * df["resilience_integration_index"] +
        0.25 * df["policy_coherence_score"] +
        0.20 * df["adaptive_governance_score"] +
        0.20 * df["synergy_capture_index"]
    ).clip(lower=0, upper=1)

    df["constrained_systemic_governance_score"] = (
        0.35 * df["policy_coherence_score"] +
        0.25 * df["adaptive_governance_score"] +
        0.25 * df["coordinated_transition_score"] +
        0.15 * (1 - df["lock_in_risk_index"])
    ).clip(lower=0, upper=1)

    df["governance_band"] = np.select(
        [
            df["constrained_systemic_governance_score"] >= 0.80,
            df["constrained_systemic_governance_score"] >= 0.60,
            df["constrained_systemic_governance_score"] >= 0.40,
        ],
        [
            "High coordination capacity",
            "Strong coordination capacity",
            "Moderate coordination capacity",
        ],
        default="Constrained coordination capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "policy_domain",
        "policy_coherence_score",
        "adaptive_governance_score",
        "coordinated_transition_score",
        "constrained_systemic_governance_score",
        "governance_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_systemic_governance_score",
            "policy_coherence_score",
            "adaptive_governance_score",
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

    print("Policy coherence and spillover scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
