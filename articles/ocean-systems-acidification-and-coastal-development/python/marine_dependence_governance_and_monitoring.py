from __future__ import annotations

import pandas as pd

INPUT_FILE = "coastal_ocean_risk_panel.csv"
OUTPUT_FILE = "marine_dependence_governance_and_monitoring_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "coastal_system_name",
        "territory_name",
        "coastal_type",
        "acidification_pressure_index",
        "marine_dependence_index",
        "fisheries_livelihood_dependence_index",
        "governance_capacity_index",
        "monitoring_readiness_index",
        "justice_exposure_index",
        "coastal_infrastructure_exposure_index",
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

    df["dependence_exposure_score"] = (
        0.35 * df["marine_dependence_index"] +
        0.30 * df["fisheries_livelihood_dependence_index"] +
        0.20 * df["coastal_infrastructure_exposure_index"] +
        0.15 * df["justice_exposure_index"]
    ).clip(0, 1)

    df["governance_gap_score"] = (
        0.40 * (1 - df["governance_capacity_index"]) +
        0.35 * (1 - df["monitoring_readiness_index"]) +
        0.25 * df["acidification_pressure_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Marine dependence, governance, and monitoring diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
