from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "law_rights_development_panel.csv"
OUTPUT_FILE = "law_rights_and_remedy_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "legal_domain",
        "rights_protection_index",
        "access_to_justice_index",
        "procedural_participation_index",
        "environmental_rights_integration_index",
        "accountability_structure_index",
        "non_discrimination_protection_index",
        "administrative_review_index",
        "enforcement_capacity_index",
        "legal_exclusion_risk_index",
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

    df["legal_protection_score"] = (
        0.22 * df["rights_protection_index"] +
        0.18 * df["non_discrimination_protection_index"] +
        0.15 * df["environmental_rights_integration_index"] +
        0.15 * df["procedural_participation_index"] +
        0.15 * df["accountability_structure_index"] +
        0.15 * df["administrative_review_index"]
    ).clip(lower=0, upper=1)

    df["remedy_capacity_score"] = (
        0.35 * df["access_to_justice_index"] +
        0.25 * df["administrative_review_index"] +
        0.20 * df["enforcement_capacity_index"] +
        0.20 * df["accountability_structure_index"]
    ).clip(lower=0, upper=1)

    df["constrained_legal_development_score"] = (
        0.45 * df["legal_protection_score"] +
        0.30 * df["remedy_capacity_score"] +
        0.15 * df["environmental_rights_integration_index"] +
        0.10 * (1 - df["legal_exclusion_risk_index"])
    ).clip(lower=0, upper=1)

    df["legal_band"] = np.select(
        [
            df["constrained_legal_development_score"] >= 0.80,
            df["constrained_legal_development_score"] >= 0.60,
            df["constrained_legal_development_score"] >= 0.40,
        ],
        [
            "High legal-development capacity",
            "Strong legal-development capacity",
            "Moderate legal-development capacity",
        ],
        default="Constrained legal-development capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "legal_domain",
        "legal_protection_score",
        "remedy_capacity_score",
        "constrained_legal_development_score",
        "legal_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_legal_development_score",
            "legal_protection_score",
            "remedy_capacity_score",
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

    print("Legal protection and remedy capacity scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
