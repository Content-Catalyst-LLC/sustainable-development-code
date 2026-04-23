from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "future_development_scenarios.csv"
OUTPUT_FILE = "future_development_viability_results.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load scenario-level sustainable development data."""
    df = pd.read_csv(path)

    required_columns = [
        "scenario",
        "income_index",
        "ecological_integrity_index",
        "resilience_index",
        "governance_capacity_index",
        "technology_capability_index",
        "justice_equity_index",
        "shock_exposure_index",
        "institutional_fragility_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_index_columns(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure normalized index columns are within [0, 1]."""
    index_columns = [
        "income_index",
        "ecological_integrity_index",
        "resilience_index",
        "governance_capacity_index",
        "technology_capability_index",
        "justice_equity_index",
        "shock_exposure_index",
        "institutional_fragility_index",
    ]

    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_viability_metrics(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute core viability and risk metrics.
    Higher scores are generally better except for shock exposure and fragility.
    """
    df["core_viability_score"] = (
        0.16 * df["income_index"] +
        0.20 * df["ecological_integrity_index"] +
        0.17 * df["resilience_index"] +
        0.16 * df["governance_capacity_index"] +
        0.13 * df["technology_capability_index"] +
        0.18 * df["justice_equity_index"]
    )

    # Penalize scenarios with high shock exposure and institutional fragility
    df["risk_penalty"] = (
        0.55 * df["shock_exposure_index"] +
        0.45 * df["institutional_fragility_index"]
    )

    df["net_viability_score"] = df["core_viability_score"] - (0.35 * df["risk_penalty"])

    # Simple threshold logic for policy interpretation
    df["viability_band"] = np.select(
        [
            df["net_viability_score"] >= 0.70,
            df["net_viability_score"] >= 0.50,
            df["net_viability_score"] >= 0.35,
        ],
        [
            "High Viability",
            "Moderate Viability",
            "Stressed Viability",
        ],
        default="Low Viability",
    )

    # A future-readiness signal based on the interaction of governance, resilience, and technology capability
    df["future_readiness_score"] = (
        0.40 * df["governance_capacity_index"] +
        0.35 * df["resilience_index"] +
        0.25 * df["technology_capability_index"]
    )

    # Inequality-sensitive stress flag
    df["equity_risk_flag"] = np.where(
        (df["justice_equity_index"] < 0.45) & (df["shock_exposure_index"] > 0.50),
        "High Equity Risk",
        "Standard Equity Risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Return a planning-oriented summary sorted by net viability."""
    summary_columns = [
        "scenario",
        "core_viability_score",
        "risk_penalty",
        "net_viability_score",
        "future_readiness_score",
        "viability_band",
        "equity_risk_flag",
    ]

    summary = df[summary_columns].copy()
    summary = summary.sort_values(
        by=["net_viability_score", "future_readiness_score"],
        ascending=[False, False],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_index_columns(df)
    df = compute_viability_metrics(df)
    summary = build_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Future development scenario analysis complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
