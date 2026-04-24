from __future__ import annotations

import pandas as pd

INPUT_FILE = "sdg_governance_monitoring_panel.csv"
OUTPUT_FILE = "implementation_and_monitoring_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "integration_complexity_index",
        "implementation_capacity_index",
        "means_of_implementation_index",
        "partnership_readiness_index",
        "monitoring_capacity_index",
        "indicator_coverage_index",
        "review_responsiveness_index",
        "policy_fragmentation_index",
        "sdg_alignment_index",
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

    df["implementation_gap_score"] = (
        0.30 * (1 - df["implementation_capacity_index"]) +
        0.25 * (1 - df["means_of_implementation_index"]) +
        0.20 * (1 - df["partnership_readiness_index"]) +
        0.15 * df["integration_complexity_index"] +
        0.10 * df["policy_fragmentation_index"]
    ).clip(0, 1)

    df["monitoring_gap_score"] = (
        0.35 * (1 - df["monitoring_capacity_index"]) +
        0.25 * (1 - df["indicator_coverage_index"]) +
        0.20 * (1 - df["review_responsiveness_index"]) +
        0.20 * (1 - df["sdg_alignment_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Implementation and monitoring diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
