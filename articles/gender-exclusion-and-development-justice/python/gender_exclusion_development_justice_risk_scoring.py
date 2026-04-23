from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "gender_exclusion_development_justice_panel.csv"
OUTPUT_FILE = "gender_exclusion_development_justice_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "education_access_index",
        "health_autonomy_index",
        "economic_participation_index",
        "care_burden_index",
        "violence_exposure_index",
        "institutional_power_gap_index",
        "property_rights_gap_index",
        "governance_capacity_index",
        "gender_transition_readiness_index",
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

    df["substantive_freedom_score"] = (
        0.24 * df["education_access_index"] +
        0.24 * df["health_autonomy_index"] +
        0.20 * df["economic_participation_index"] +
        0.16 * (1 - df["violence_exposure_index"]) +
        0.16 * (1 - df["property_rights_gap_index"])
    ).clip(lower=0, upper=1)

    df["gender_exclusion_score"] = (
        0.22 * df["care_burden_index"] +
        0.22 * df["violence_exposure_index"] +
        0.20 * df["institutional_power_gap_index"] +
        0.18 * df["property_rights_gap_index"] +
        0.18 * (1 - df["economic_participation_index"])
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["gender_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["gender_development_justice_risk_score"] = (
        0.40 * df["gender_exclusion_score"] +
        0.25 * (1 - df["substantive_freedom_score"]) +
        0.20 * df["violence_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["gender_development_justice_risk_score"] >= 0.80,
            df["gender_development_justice_risk_score"] >= 0.60,
            df["gender_development_justice_risk_score"] >= 0.40,
        ],
        [
            "Extreme gender-justice risk",
            "High gender-justice risk",
            "Moderate gender-justice risk",
        ],
        default="Lower gender-justice risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "substantive_freedom_score",
        "gender_exclusion_score",
        "governance_readiness_score",
        "gender_development_justice_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "gender_development_justice_risk_score",
            "gender_exclusion_score",
            "substantive_freedom_score",
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

    print("Gender exclusion and development justice scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
