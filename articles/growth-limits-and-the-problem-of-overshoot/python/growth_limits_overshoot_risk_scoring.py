from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "growth_limits_overshoot_panel.csv"
OUTPUT_FILE = "growth_limits_overshoot_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "growth_pressure_index",
        "throughput_pressure_index",
        "resource_depletion_index",
        "waste_absorptive_stress_index",
        "planetary_pressure_index",
        "delay_recognition_risk_index",
        "infrastructure_lockin_index",
        "governance_fragility_index",
        "adaptive_capacity_index",
        "welfare_conversion_index",
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

    df["overshoot_pressure_score"] = (
        0.16 * df["growth_pressure_index"] +
        0.16 * df["throughput_pressure_index"] +
        0.14 * df["resource_depletion_index"] +
        0.14 * df["waste_absorptive_stress_index"] +
        0.14 * df["planetary_pressure_index"] +
        0.13 * df["delay_recognition_risk_index"] +
        0.13 * df["infrastructure_lockin_index"]
    ).clip(lower=0, upper=1)

    df["stability_support_score"] = (
        0.35 * (1 - df["governance_fragility_index"]) +
        0.35 * df["adaptive_capacity_index"] +
        0.30 * df["welfare_conversion_index"]
    ).clip(lower=0, upper=1)

    df["overshoot_risk_score"] = (
        0.50 * df["overshoot_pressure_score"] +
        0.20 * df["governance_fragility_index"] +
        0.15 * (1 - df["adaptive_capacity_index"]) +
        0.15 * (1 - df["welfare_conversion_index"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["overshoot_risk_score"] >= 0.80,
            df["overshoot_risk_score"] >= 0.60,
            df["overshoot_risk_score"] >= 0.40,
        ],
        [
            "Extreme overshoot risk",
            "High overshoot risk",
            "Moderate overshoot risk",
        ],
        default="Lower overshoot risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "overshoot_pressure_score",
        "stability_support_score",
        "overshoot_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "overshoot_risk_score",
            "overshoot_pressure_score",
            "stability_support_score",
        ],
        ascending=[False, False, True],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Growth, limits, and overshoot scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
