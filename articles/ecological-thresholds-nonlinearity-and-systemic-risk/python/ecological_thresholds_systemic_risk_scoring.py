from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "ecological_thresholds_panel.csv"
OUTPUT_FILE = "ecological_thresholds_systemic_risk_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "system_name",
        "country_or_region",
        "ecosystem_type",
        "cumulative_pressure_index",
        "slow_variable_deterioration_index",
        "feedback_intensity_index",
        "cascade_exposure_index",
        "resilience_buffer_index",
        "recovery_difficulty_index",
        "monitoring_readiness_index",
        "precaution_capacity_index",
        "justice_exposure_index",
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

    df["threshold_sensitivity_score"] = (
        0.24 * df["cumulative_pressure_index"] +
        0.18 * df["slow_variable_deterioration_index"] +
        0.20 * df["feedback_intensity_index"] +
        0.18 * df["recovery_difficulty_index"] +
        0.20 * (1 - df["resilience_buffer_index"])
    ).clip(lower=0, upper=1)

    df["systemic_cascade_score"] = (
        0.40 * df["cascade_exposure_index"] +
        0.20 * df["feedback_intensity_index"] +
        0.20 * df["justice_exposure_index"] +
        0.20 * df["cumulative_pressure_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.45 * df["monitoring_readiness_index"] +
        0.35 * df["precaution_capacity_index"] +
        0.20 * df["resilience_buffer_index"]
    ).clip(lower=0, upper=1)

    df["constrained_threshold_risk_score"] = (
        0.45 * df["threshold_sensitivity_score"] +
        0.30 * df["systemic_cascade_score"] +
        0.15 * df["justice_exposure_index"] +
        0.10 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["threshold_band"] = np.select(
        [
            df["constrained_threshold_risk_score"] >= 0.80,
            df["constrained_threshold_risk_score"] >= 0.60,
            df["constrained_threshold_risk_score"] >= 0.40,
        ],
        [
            "Extreme threshold risk",
            "High threshold risk",
            "Moderate threshold risk",
        ],
        default="Lower threshold risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "system_name",
        "country_or_region",
        "ecosystem_type",
        "threshold_sensitivity_score",
        "systemic_cascade_score",
        "governance_readiness_score",
        "constrained_threshold_risk_score",
        "threshold_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_threshold_risk_score",
            "threshold_sensitivity_score",
            "systemic_cascade_score",
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

    print("Ecological threshold and systemic-risk scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
