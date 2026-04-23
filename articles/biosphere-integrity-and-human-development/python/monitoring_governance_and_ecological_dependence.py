from __future__ import annotations

import pandas as pd

INPUT_FILE = "biosphere_governance_panel.csv"
OUTPUT_FILE = "monitoring_governance_and_ecological_dependence_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "ecosystem_degradation_index",
        "fragmentation_risk_index",
        "ecological_service_erosion_index",
        "justice_exposure_index",
        "governance_capacity_index",
        "restoration_readiness_index",
        "livelihood_ecological_dependence_index",
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

    df["governance_gap_score"] = (
        0.35 * (1 - df["governance_capacity_index"]) +
        0.30 * (1 - df["restoration_readiness_index"]) +
        0.20 * df["fragmentation_risk_index"] +
        0.15 * df["ecosystem_degradation_index"]
    ).clip(0, 1)

    df["ecological_dependence_burden_score"] = (
        0.30 * df["livelihood_ecological_dependence_index"] +
        0.25 * df["ecological_service_erosion_index"] +
        0.25 * df["justice_exposure_index"] +
        0.20 * df["ecosystem_degradation_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Monitoring, governance, and ecological dependence diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
