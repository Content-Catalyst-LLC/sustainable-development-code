from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "land_system_change_panel.csv"
OUTPUT_FILE = "land_system_change_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "conversion_pressure_index",
        "land_degradation_index",
        "fragmentation_risk_index",
        "biodiversity_function_loss_index",
        "food_settlement_dependence_index",
        "infrastructure_expansion_pressure_index",
        "justice_exposure_index",
        "governance_capacity_index",
        "restoration_readiness_index",
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

    df["territorial_stress_score"] = (
        0.22 * df["conversion_pressure_index"] +
        0.22 * df["land_degradation_index"] +
        0.18 * df["fragmentation_risk_index"] +
        0.18 * df["biodiversity_function_loss_index"] +
        0.20 * df["infrastructure_expansion_pressure_index"]
    ).clip(lower=0, upper=1)

    df["development_dependence_score"] = (
        0.55 * df["food_settlement_dependence_index"] +
        0.25 * df["justice_exposure_index"] +
        0.20 * df["biodiversity_function_loss_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["restoration_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_land_pathway_risk_score"] = (
        0.40 * df["territorial_stress_score"] +
        0.25 * df["development_dependence_score"] +
        0.20 * df["justice_exposure_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_land_pathway_risk_score"] >= 0.80,
            df["constrained_land_pathway_risk_score"] >= 0.60,
            df["constrained_land_pathway_risk_score"] >= 0.40,
        ],
        [
            "Extreme land-pathway risk",
            "High land-pathway risk",
            "Moderate land-pathway risk",
        ],
        default="Lower land-pathway risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "territorial_stress_score",
        "development_dependence_score",
        "governance_readiness_score",
        "constrained_land_pathway_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_land_pathway_risk_score",
            "territorial_stress_score",
            "development_dependence_score",
        ],
        ascending=[False, False, False],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Land-system change and development pathway scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
