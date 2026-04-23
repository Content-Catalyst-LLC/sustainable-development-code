from __future__ import annotations

import pandas as pd

INPUT_FILE = "pollution_governance_panel.csv"
OUTPUT_FILE = "governance_monitoring_and_remediation_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "waste_system_overload_index",
        "assessment_lag_index",
        "exposure_inequality_index",
        "governance_capacity_index",
        "remediation_readiness_index",
        "ecosystem_toxicity_index",
        "public_health_burden_index",
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
        0.30 * (1 - df["remediation_readiness_index"]) +
        0.20 * df["assessment_lag_index"] +
        0.15 * df["waste_system_overload_index"]
    ).clip(0, 1)

    df["social_toxicity_score"] = (
        0.35 * df["public_health_burden_index"] +
        0.30 * df["exposure_inequality_index"] +
        0.20 * df["ecosystem_toxicity_index"] +
        0.15 * df["waste_system_overload_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Governance, monitoring, and remediation diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
