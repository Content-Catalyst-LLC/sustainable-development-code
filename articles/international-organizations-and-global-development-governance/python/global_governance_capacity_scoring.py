from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "global_development_governance_panel.csv"
OUTPUT_FILE = "global_development_governance_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country_or_regime",
        "region",
        "governance_domain",
        "coordination_strength_index",
        "financing_support_index",
        "knowledge_standards_index",
        "implementation_support_index",
        "legitimacy_index",
        "resilience_coordination_index",
        "fragmentation_risk_index",
        "unequal_influence_risk_index",
        "institutional_lockin_risk_index",
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

    df["multilateral_capacity_score"] = (
        0.22 * df["coordination_strength_index"] +
        0.18 * df["financing_support_index"] +
        0.18 * df["knowledge_standards_index"] +
        0.16 * df["implementation_support_index"] +
        0.14 * df["legitimacy_index"] +
        0.12 * df["resilience_coordination_index"]
    ).clip(lower=0, upper=1)

    df["institutional_friction_score"] = (
        0.40 * df["fragmentation_risk_index"] +
        0.30 * df["unequal_influence_risk_index"] +
        0.30 * df["institutional_lockin_risk_index"]
    ).clip(lower=0, upper=1)

    df["constrained_global_governance_score"] = (
        0.65 * df["multilateral_capacity_score"] +
        0.15 * df["legitimacy_index"] +
        0.10 * df["implementation_support_index"] +
        0.10 * (1 - df["institutional_friction_score"])
    ).clip(lower=0, upper=1)

    df["governance_band"] = np.select(
        [
            df["constrained_global_governance_score"] >= 0.80,
            df["constrained_global_governance_score"] >= 0.60,
            df["constrained_global_governance_score"] >= 0.40,
        ],
        [
            "High multilateral capacity",
            "Strong multilateral capacity",
            "Moderate multilateral capacity",
        ],
        default="Constrained multilateral capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country_or_regime",
        "region",
        "governance_domain",
        "multilateral_capacity_score",
        "institutional_friction_score",
        "constrained_global_governance_score",
        "governance_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_global_governance_score",
            "multilateral_capacity_score",
            "institutional_friction_score",
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

    print("Global development governance capacity scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
