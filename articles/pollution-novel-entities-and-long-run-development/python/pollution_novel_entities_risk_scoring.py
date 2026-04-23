from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "pollution_novel_entities_panel.csv"
OUTPUT_FILE = "pollution_novel_entities_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "hazardous_material_throughput_index",
        "waste_system_overload_index",
        "persistence_mobility_risk_index",
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

    df["material_risk_score"] = (
        0.24 * df["hazardous_material_throughput_index"] +
        0.18 * df["waste_system_overload_index"] +
        0.22 * df["persistence_mobility_risk_index"] +
        0.18 * df["ecosystem_toxicity_index"] +
        0.18 * df["public_health_burden_index"]
    ).clip(lower=0, upper=1)

    df["novel_entities_pressure_score"] = (
        0.45 * df["assessment_lag_index"] +
        0.30 * df["persistence_mobility_risk_index"] +
        0.25 * df["hazardous_material_throughput_index"]
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["remediation_readiness_index"]
    ).clip(lower=0, upper=1)

    df["constrained_pollution_development_score"] = (
        0.40 * df["material_risk_score"] +
        0.25 * df["novel_entities_pressure_score"] +
        0.20 * df["exposure_inequality_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["constrained_pollution_development_score"] >= 0.80,
            df["constrained_pollution_development_score"] >= 0.60,
            df["constrained_pollution_development_score"] >= 0.40,
        ],
        [
            "Extreme pollution-development risk",
            "High pollution-development risk",
            "Moderate pollution-development risk",
        ],
        default="Lower pollution-development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "material_risk_score",
        "novel_entities_pressure_score",
        "governance_readiness_score",
        "constrained_pollution_development_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_pollution_development_score",
            "material_risk_score",
            "novel_entities_pressure_score",
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

    print("Pollution and novel-entities development risk scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
