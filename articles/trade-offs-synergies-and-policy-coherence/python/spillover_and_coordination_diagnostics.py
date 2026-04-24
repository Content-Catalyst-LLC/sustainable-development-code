from __future__ import annotations

import pandas as pd

INPUT_FILE = "policy_coherence_governance_panel.csv"
OUTPUT_FILE = "spillover_and_coordination_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "tradeoff_intensity_index",
        "synergy_realization_index",
        "sectoral_spillover_index",
        "transboundary_spillover_index",
        "intergenerational_spillover_index",
        "coordination_capacity_index",
        "impact_assessment_index",
        "monitoring_review_index",
        "sequencing_capacity_index",
        "governance_fragmentation_index",
        "policy_alignment_index",
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

    df["spillover_pressure_score"] = (
        0.30 * df["sectoral_spillover_index"] +
        0.25 * df["transboundary_spillover_index"] +
        0.25 * df["intergenerational_spillover_index"] +
        0.20 * df["tradeoff_intensity_index"]
    ).clip(0, 1)

    df["coordination_gap_score"] = (
        0.30 * (1 - df["coordination_capacity_index"]) +
        0.20 * (1 - df["impact_assessment_index"]) +
        0.20 * (1 - df["monitoring_review_index"]) +
        0.15 * (1 - df["sequencing_capacity_index"]) +
        0.15 * df["governance_fragmentation_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Spillover and coordination diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
