from __future__ import annotations

import pandas as pd

INPUT_FILE = "land_governance_panel.csv"
OUTPUT_FILE = "governance_restoration_and_exposure_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "conversion_pressure_index",
        "land_degradation_index",
        "fragmentation_risk_index",
        "justice_exposure_index",
        "governance_capacity_index",
        "restoration_readiness_index",
        "biodiversity_function_loss_index",
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
        0.15 * df["conversion_pressure_index"]
    ).clip(0, 1)

    df["territorial_exposure_score"] = (
        0.30 * df["land_degradation_index"] +
        0.25 * df["justice_exposure_index"] +
        0.25 * df["biodiversity_function_loss_index"] +
        0.20 * df["fragmentation_risk_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Governance, restoration, and territorial exposure diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
