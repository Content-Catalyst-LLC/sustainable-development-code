from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "institutions_development_panel.csv"
OUTPUT_FILE = "institutional_capacity_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "institutional_domain",
        "implementation_capacity_index",
        "coordination_capacity_index",
        "trust_support_index",
        "accountability_strength_index",
        "delivery_system_reliability_index",
        "learning_capacity_index",
        "legal_administrative_clarity_index",
        "fragmentation_risk_index",
        "capture_risk_index",
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

    df["institutional_effectiveness_score"] = (
        0.20 * df["implementation_capacity_index"] +
        0.16 * df["coordination_capacity_index"] +
        0.14 * df["delivery_system_reliability_index"] +
        0.14 * df["accountability_strength_index"] +
        0.12 * df["learning_capacity_index"] +
        0.12 * df["legal_administrative_clarity_index"] +
        0.12 * df["trust_support_index"]
    ).clip(lower=0, upper=1)

    df["institutional_fragility_score"] = (
        0.45 * df["fragmentation_risk_index"] +
        0.35 * df["capture_risk_index"] +
        0.20 * (1 - df["trust_support_index"])
    ).clip(lower=0, upper=1)

    df["constrained_institutional_capacity_score"] = (
        0.65 * df["institutional_effectiveness_score"] +
        0.15 * df["implementation_capacity_index"] +
        0.10 * df["learning_capacity_index"] +
        0.10 * (1 - df["institutional_fragility_score"])
    ).clip(lower=0, upper=1)

    df["institutional_band"] = np.select(
        [
            df["constrained_institutional_capacity_score"] >= 0.80,
            df["constrained_institutional_capacity_score"] >= 0.60,
            df["constrained_institutional_capacity_score"] >= 0.40,
        ],
        [
            "High institutional capacity",
            "Strong institutional capacity",
            "Moderate institutional capacity",
        ],
        default="Constrained institutional capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "institutional_domain",
        "institutional_effectiveness_score",
        "institutional_fragility_score",
        "constrained_institutional_capacity_score",
        "institutional_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_institutional_capacity_score",
            "institutional_effectiveness_score",
            "institutional_fragility_score",
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

    print("Institutional capacity and delivery-system scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
