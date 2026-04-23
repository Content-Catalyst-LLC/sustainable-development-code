from __future__ import annotations

import pandas as pd

INPUT_FILE = "urban_governance_panel.csv"
OUTPUT_FILE = "housing_gap_and_service_fragility_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "housing_adequacy_index",
        "housing_affordability_stress_index",
        "basic_services_access_index",
        "informality_exclusion_index",
        "resilience_weakness_index",
        "governance_capacity_index",
        "urban_transition_readiness_index",
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

    df["housing_gap_score"] = (
        0.35 * (1 - df["housing_adequacy_index"]) +
        0.35 * df["housing_affordability_stress_index"] +
        0.15 * df["informality_exclusion_index"] +
        0.15 * (1 - df["basic_services_access_index"])
    ).clip(0, 1)

    df["service_fragility_score"] = (
        0.30 * (1 - df["basic_services_access_index"]) +
        0.25 * df["resilience_weakness_index"] +
        0.25 * (1 - df["governance_capacity_index"]) +
        0.20 * (1 - df["urban_transition_readiness_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Housing gap and service fragility diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
