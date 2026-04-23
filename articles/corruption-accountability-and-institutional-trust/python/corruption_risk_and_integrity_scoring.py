from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "corruption_integrity_panel.csv"
OUTPUT_FILE = "corruption_risk_and_integrity_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "institutional_domain",
        "procurement_integrity_index",
        "accountability_strength_index",
        "service_integrity_index",
        "beneficial_ownership_visibility_index",
        "audit_capacity_index",
        "complaint_access_index",
        "trust_support_index",
        "capture_risk_index",
        "selective_enforcement_risk_index",
        "corruption_visibility_gap_index",
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

    df["integrity_system_score"] = (
        0.20 * df["procurement_integrity_index"] +
        0.18 * df["accountability_strength_index"] +
        0.14 * df["service_integrity_index"] +
        0.14 * df["beneficial_ownership_visibility_index"] +
        0.14 * df["audit_capacity_index"] +
        0.10 * df["complaint_access_index"] +
        0.10 * df["trust_support_index"]
    ).clip(lower=0, upper=1)

    df["institutional_distortion_risk_score"] = (
        0.30 * df["capture_risk_index"] +
        0.25 * df["selective_enforcement_risk_index"] +
        0.20 * (1 - df["procurement_integrity_index"]) +
        0.15 * (1 - df["service_integrity_index"]) +
        0.10 * df["corruption_visibility_gap_index"]
    ).clip(lower=0, upper=1)

    df["constrained_integrity_score"] = (
        0.55 * df["integrity_system_score"] +
        0.20 * df["accountability_strength_index"] +
        0.15 * df["trust_support_index"] +
        0.10 * (1 - df["institutional_distortion_risk_score"])
    ).clip(lower=0, upper=1)

    df["integrity_band"] = np.select(
        [
            df["constrained_integrity_score"] >= 0.80,
            df["constrained_integrity_score"] >= 0.60,
            df["constrained_integrity_score"] >= 0.40,
        ],
        [
            "High integrity capacity",
            "Strong integrity capacity",
            "Moderate integrity capacity",
        ],
        default="Constrained integrity capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "institutional_domain",
        "integrity_system_score",
        "institutional_distortion_risk_score",
        "constrained_integrity_score",
        "integrity_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_integrity_score",
            "integrity_system_score",
            "institutional_distortion_risk_score",
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

    print("Corruption risk and institutional integrity scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
