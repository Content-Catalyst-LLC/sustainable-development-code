from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "resilience_system_data.csv"
OUTPUT_FILE = "resilience_system_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load resilience-related system data from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "system_name",
        "region",
        "disturbance_exposure_index",
        "coping_capacity_index",
        "adaptive_capacity_index",
        "transformative_capacity_index",
        "institutional_learning_index",
        "ecological_buffer_index",
        "equity_protection_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure all normalized index fields are bounded between 0 and 1."""
    index_columns = [
        "disturbance_exposure_index",
        "coping_capacity_index",
        "adaptive_capacity_index",
        "transformative_capacity_index",
        "institutional_learning_index",
        "ecological_buffer_index",
        "equity_protection_index",
    ]

    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_resilience_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute composite resilience and brittleness scores."""
    df["resilience_capacity_score"] = (
        0.20 * df["coping_capacity_index"] +
        0.20 * df["adaptive_capacity_index"] +
        0.20 * df["transformative_capacity_index"] +
        0.15 * df["institutional_learning_index"] +
        0.15 * df["ecological_buffer_index"] +
        0.10 * df["equity_protection_index"]
    )

    df["brittleness_score"] = (
        0.65 * df["disturbance_exposure_index"]
        - 0.35 * df["resilience_capacity_score"]
    ).clip(lower=0)

    df["governance_ecology_balance"] = (
        df["institutional_learning_index"] - df["ecological_buffer_index"]
    )

    df["resilience_band"] = np.select(
        [
            df["resilience_capacity_score"] >= 0.75,
            df["resilience_capacity_score"] >= 0.55,
            df["resilience_capacity_score"] >= 0.35,
        ],
        [
            "High resilience",
            "Moderate resilience",
            "Stressed resilience",
        ],
        default="Low resilience",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Build a summary table sorted by resilience capacity."""
    summary_columns = [
        "system_name",
        "region",
        "disturbance_exposure_index",
        "resilience_capacity_score",
        "brittleness_score",
        "governance_ecology_balance",
        "resilience_band",
    ]

    summary = df[summary_columns].copy()
    summary = summary.sort_values(
        by=["resilience_capacity_score", "brittleness_score"],
        ascending=[False, True],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    df = compute_resilience_score(df)

    summary = build_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Resilience scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
