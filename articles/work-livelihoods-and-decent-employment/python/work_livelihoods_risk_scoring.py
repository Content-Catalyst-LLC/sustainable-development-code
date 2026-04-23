from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "work_livelihoods_panel.csv"
OUTPUT_FILE = "work_livelihoods_decent_employment_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "employment_access_index",
        "informality_risk_index",
        "precarity_risk_index",
        "income_security_index",
        "social_protection_coverage_index",
        "labour_rights_exposure_index",
        "youth_exclusion_index",
        "gender_livelihood_gap_index",
        "transition_readiness_index",
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

    df["livelihood_security_score"] = (
        0.30 * df["employment_access_index"] +
        0.25 * df["income_security_index"] +
        0.25 * df["social_protection_coverage_index"] +
        0.20 * (1 - df["labour_rights_exposure_index"])
    ).clip(lower=0, upper=1)

    df["labour_fragility_score"] = (
        0.24 * df["informality_risk_index"] +
        0.24 * df["precarity_risk_index"] +
        0.18 * (1 - df["income_security_index"]) +
        0.17 * df["youth_exclusion_index"] +
        0.17 * df["gender_livelihood_gap_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["social_protection_coverage_index"] +
        0.45 * df["transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["decent_employment_risk_score"] = (
        0.40 * df["labour_fragility_score"] +
        0.25 * (1 - df["livelihood_security_score"]) +
        0.20 * df["labour_rights_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["decent_employment_risk_score"] >= 0.80,
            df["decent_employment_risk_score"] >= 0.60,
            df["decent_employment_risk_score"] >= 0.40,
        ],
        [
            "Extreme decent-employment risk",
            "High decent-employment risk",
            "Moderate decent-employment risk",
        ],
        default="Lower decent-employment risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "livelihood_security_score",
        "labour_fragility_score",
        "governance_readiness_score",
        "decent_employment_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "decent_employment_risk_score",
            "labour_fragility_score",
            "livelihood_security_score",
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

    print("Work, livelihoods, and decent employment scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
