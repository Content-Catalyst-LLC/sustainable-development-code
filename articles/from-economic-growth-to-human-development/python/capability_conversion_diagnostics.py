from __future__ import annotations

import pandas as pd

INPUT_FILE = "human_development_governance_panel.csv"
OUTPUT_FILE = "capability_conversion_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "output_growth_index",
        "health_capability_index",
        "education_capability_index",
        "income_conversion_index",
        "public_goods_conversion_index",
        "distribution_constraint_index",
        "institutional_support_index",
        "agency_freedom_index",
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

    df["capability_translation_gap_score"] = (
        0.25 * (1 - df["income_conversion_index"]) +
        0.25 * (1 - df["public_goods_conversion_index"]) +
        0.20 * df["distribution_constraint_index"] +
        0.15 * (1 - df["institutional_support_index"]) +
        0.15 * (1 - df["agency_freedom_index"])
    ).clip(0, 1)

    df["capability_realisation_score"] = (
        0.35 * df["health_capability_index"] +
        0.35 * df["education_capability_index"] +
        0.30 * df["agency_freedom_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Capability-conversion diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
