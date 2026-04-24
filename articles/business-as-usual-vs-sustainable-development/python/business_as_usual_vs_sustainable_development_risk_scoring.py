from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "business_as_usual_vs_sustainable_development_panel.csv"
OUTPUT_FILE = "business_as_usual_vs_sustainable_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "fossil_dependence_index",
        "resource_throughput_pressure_index",
        "urban_lock_in_index",
        "inequality_pressure_index",
        "public_goods_inclusion_index",
        "ecological_stress_index",
        "governance_transition_capacity_index",
        "clean_technology_adoption_index",
        "sustainable_development_alignment_index",
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

    df["business_as_usual_pressure_score"] = (
        0.16 * df["fossil_dependence_index"] +
        0.14 * df["resource_throughput_pressure_index"] +
        0.12 * df["urban_lock_in_index"] +
        0.12 * df["inequality_pressure_index"] +
        0.16 * df["ecological_stress_index"] +
        0.10 * (1 - df["public_goods_inclusion_index"]) +
        0.10 * (1 - df["governance_transition_capacity_index"]) +
        0.10 * (1 - df["sustainable_development_alignment_index"])
    ).clip(lower=0, upper=1)

    df["sustainable_transition_capacity_score"] = (
        0.20 * df["public_goods_inclusion_index"] +
        0.18 * df["governance_transition_capacity_index"] +
        0.18 * df["clean_technology_adoption_index"] +
        0.16 * (1 - df["fossil_dependence_index"]) +
        0.14 * (1 - df["urban_lock_in_index"]) +
        0.14 * df["sustainable_development_alignment_index"]
    ).clip(lower=0, upper=1)

    df["business_as_usual_risk_score"] = (
        0.50 * df["business_as_usual_pressure_score"] +
        0.30 * (1 - df["sustainable_transition_capacity_score"]) +
        0.20 * df["ecological_stress_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["business_as_usual_risk_score"] >= 0.80,
            df["business_as_usual_risk_score"] >= 0.60,
            df["business_as_usual_risk_score"] >= 0.40,
        ],
        [
            "Extreme business-as-usual risk",
            "High business-as-usual risk",
            "Moderate business-as-usual risk",
        ],
        default="Lower business-as-usual risk",
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
