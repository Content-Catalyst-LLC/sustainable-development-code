from __future__ import annotations

import pandas as pd

INPUT_FILE = "indicator_governance_panel.csv"
OUTPUT_FILE = "coverage_robustness_and_hidden_burden_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "inequality_penalty_index",
        "gender_gap_index",
        "multidimensional_poverty_index",
        "subnational_variation_index",
        "data_quality_confidence_index",
        "indicator_coverage_index",
        "security_exclusion_index",
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

    df["coverage_gap_score"] = (
        0.35 * (1 - df["indicator_coverage_index"]) +
        0.35 * (1 - df["data_quality_confidence_index"]) +
        0.15 * df["subnational_variation_index"] +
        0.15 * df["security_exclusion_index"]
    ).clip(0, 1)

    df["hidden_burden_signal_score"] = (
        0.25 * df["inequality_penalty_index"] +
        0.20 * df["gender_gap_index"] +
        0.25 * df["multidimensional_poverty_index"] +
        0.15 * df["subnational_variation_index"] +
        0.15 * df["security_exclusion_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Coverage, robustness, and hidden-burden diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
