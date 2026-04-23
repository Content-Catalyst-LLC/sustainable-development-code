from __future__ import annotations

import pandas as pd

INPUT_FILE = "health_education_governance_panel.csv"
OUTPUT_FILE = "service_quality_and_access_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "health_access_index",
        "education_access_index",
        "service_quality_index",
        "financial_hardship_risk_index",
        "learning_deprivation_index",
        "governance_capacity_index",
        "capability_transition_readiness_index",
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

    df["service_gap_score"] = (
        0.25 * (1 - df["health_access_index"]) +
        0.25 * (1 - df["education_access_index"]) +
        0.25 * (1 - df["service_quality_index"]) +
        0.25 * df["financial_hardship_risk_index"]
    ).clip(0, 1)

    df["institutional_delivery_risk_score"] = (
        0.35 * (1 - df["governance_capacity_index"]) +
        0.25 * (1 - df["capability_transition_readiness_index"]) +
        0.20 * df["learning_deprivation_index"] +
        0.20 * df["financial_hardship_risk_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Service-quality and access diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
