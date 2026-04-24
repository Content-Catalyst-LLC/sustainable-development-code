from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "geography_global_poverty_panel.csv"
OUTPUT_FILE = "geography_global_poverty_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "income_deprivation_index",
        "rural_ecological_vulnerability_index",
        "urban_informal_settlement_pressure_index",
        "health_burden_index",
        "infrastructure_exclusion_index",
        "regional_isolation_index",
        "conflict_fragility_exposure_index",
        "basic_services_access_index",
        "territorial_governance_capacity_index",
        "poverty_reduction_alignment_index",
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

    df["territorial_poverty_pressure_score"] = (
        0.16 * df["income_deprivation_index"] +
        0.12 * df["rural_ecological_vulnerability_index"] +
        0.12 * df["urban_informal_settlement_pressure_index"] +
        0.12 * df["health_burden_index"] +
        0.14 * df["infrastructure_exclusion_index"] +
        0.10 * df["regional_isolation_index"] +
        0.12 * df["conflict_fragility_exposure_index"] +
        0.12 * (1 - df["basic_services_access_index"])
    ).clip(lower=0, upper=1)

    df["spatial_inclusion_capacity_score"] = (
        0.24 * df["basic_services_access_index"] +
        0.22 * df["territorial_governance_capacity_index"] +
        0.18 * (1 - df["regional_isolation_index"]) +
        0.18 * (1 - df["infrastructure_exclusion_index"]) +
        0.18 * df["poverty_reduction_alignment_index"]
    ).clip(lower=0, upper=1)

    df["geographic_poverty_risk_score"] = (
        0.50 * df["territorial_poverty_pressure_score"] +
        0.30 * (1 - df["spatial_inclusion_capacity_score"]) +
        0.20 * df["conflict_fragility_exposure_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["geographic_poverty_risk_score"] >= 0.80,
            df["geographic_poverty_risk_score"] >= 0.60,
            df["geographic_poverty_risk_score"] >= 0.40,
        ],
        [
            "Extreme geographic-poverty risk",
            "High geographic-poverty risk",
            "Moderate geographic-poverty risk",
        ],
        default="Lower geographic-poverty risk",
    )

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    scored.to_csv(OUTPUT_FILE, index=False)
    print(scored.to_string(index=False))


if __name__ == "__main__":
    main()
