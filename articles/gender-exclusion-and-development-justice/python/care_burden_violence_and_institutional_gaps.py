from __future__ import annotations

import pandas as pd

INPUT_FILE = "gender_governance_panel.csv"
OUTPUT_FILE = "care_burden_violence_and_institutional_gaps_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "care_burden_index",
        "violence_exposure_index",
        "institutional_power_gap_index",
        "property_rights_gap_index",
        "economic_participation_index",
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

    df["institutional_gap_score"] = (
        0.30 * df["institutional_power_gap_index"] +
        0.25 * df["property_rights_gap_index"] +
        0.25 * (1 - df["governance_capacity_index"]) +
        0.20 * (1 - df["gender_transition_readiness_index"])
    ).clip(0, 1)

    df["care_security_burden_score"] = (
        0.35 * df["care_burden_index"] +
        0.35 * df["violence_exposure_index"] +
        0.15 * (1 - df["economic_participation_index"]) +
        0.15 * (1 - df["governance_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Care burden, violence, and institutional-gap diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
