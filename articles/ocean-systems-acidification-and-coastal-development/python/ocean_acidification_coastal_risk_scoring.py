from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "ocean_acidification_coastal_panel.csv"
OUTPUT_FILE = "ocean_acidification_coastal_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "coastal_system_name",
        "country_or_region",
        "coastal_type",
        "acidification_pressure_index",
        "warming_pressure_index",
        "deoxygenation_pressure_index",
        "marine_dependence_index",
        "fisheries_livelihood_dependence_index",
        "coastal_infrastructure_exposure_index",
        "governance_capacity_index",
        "justice_exposure_index",
        "monitoring_readiness_index",
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

    df["marine_habitability_stress_score"] = (
        0.36 * df["acidification_pressure_index"] +
        0.32 * df["warming_pressure_index"] +
        0.32 * df["deoxygenation_pressure_index"]
    ).clip(lower=0, upper=1)

    df["coastal_dependence_score"] = (
        0.40 * df["marine_dependence_index"] +
        0.35 * df["fisheries_livelihood_dependence_index"] +
        0.25 * df["coastal_infrastructure_exposure_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["monitoring_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_coastal_ocean_risk_score"] = (
        0.40 * df["marine_habitability_stress_score"] +
        0.30 * df["coastal_dependence_score"] +
        0.20 * df["justice_exposure_index"] +
        0.10 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_coastal_ocean_risk_score"] >= 0.80,
            df["constrained_coastal_ocean_risk_score"] >= 0.60,
            df["constrained_coastal_ocean_risk_score"] >= 0.40,
        ],
        [
            "Extreme coastal-ocean risk",
            "High coastal-ocean risk",
            "Moderate coastal-ocean risk",
        ],
        default="Lower coastal-ocean risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "coastal_system_name",
        "country_or_region",
        "coastal_type",
        "marine_habitability_stress_score",
        "coastal_dependence_score",
        "governance_readiness_score",
        "constrained_coastal_ocean_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_coastal_ocean_risk_score",
            "marine_habitability_stress_score",
            "coastal_dependence_score",
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

    print("Ocean acidification and coastal development risk scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
