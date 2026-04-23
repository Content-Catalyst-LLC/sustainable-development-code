from __future__ import annotations

import pandas as pd

INPUT_FILE = "territorial_risk_panel.csv"
OUTPUT_FILE = "fragmentation_resilience_and_implementation_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "city_or_region",
        "territory_name",
        "territory_type",
        "resilience_capacity_index",
        "multilevel_alignment_index",
        "service_reach_index",
        "fragmentation_risk_index",
        "informality_pressure_index",
        "hazard_exposure_index",
        "spatial_justice_index",
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

    df["implementation_resilience_score"] = (
        0.35 * df["resilience_capacity_index"] +
        0.25 * df["multilevel_alignment_index"] +
        0.20 * df["service_reach_index"] +
        0.20 * df["spatial_justice_index"]
    ).clip(0, 1)

    df["territorial_fragility_score"] = (
        0.35 * df["fragmentation_risk_index"] +
        0.35 * df["hazard_exposure_index"] +
        0.30 * df["informality_pressure_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Fragmentation, resilience, and implementation diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
