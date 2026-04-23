from __future__ import annotations

import pandas as pd

INPUT_FILE = "work_governance_panel.csv"
OUTPUT_FILE = "labour_fragility_and_protection_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "informality_risk_index",
        "precarity_risk_index",
        "income_security_index",
        "social_protection_coverage_index",
        "labour_rights_exposure_index",
        "youth_exclusion_index",
        "gender_livelihood_gap_index",
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

    df["protection_gap_score"] = (
        0.35 * (1 - df["social_protection_coverage_index"]) +
        0.30 * df["labour_rights_exposure_index"] +
        0.20 * df["precarity_risk_index"] +
        0.15 * df["informality_risk_index"]
    ).clip(0, 1)

    df["exclusion_burden_score"] = (
        0.25 * df["youth_exclusion_index"] +
        0.25 * df["gender_livelihood_gap_index"] +
        0.25 * df["informality_risk_index"] +
        0.25 * (1 - df["income_security_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Labour fragility and protection diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
