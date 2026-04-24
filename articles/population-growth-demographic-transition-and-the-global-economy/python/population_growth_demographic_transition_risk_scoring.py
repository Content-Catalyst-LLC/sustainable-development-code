from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "population_growth_global_economy_panel.csv"
OUTPUT_FILE = "population_growth_global_economy_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "youth_dependency_index",
        "old_age_dependency_index",
        "working_age_share_index",
        "labor_absorption_capacity_index",
        "human_capital_investment_index",
        "urbanization_pressure_index",
        "infrastructure_capacity_index",
        "ecological_throughput_pressure_index",
        "governance_capacity_index",
        "demographic_transition_alignment_index",
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

    df["demographic_pressure_score"] = (
        0.14 * df["youth_dependency_index"] +
        0.12 * df["old_age_dependency_index"] +
        0.12 * (1 - df["labor_absorption_capacity_index"]) +
        0.12 * (1 - df["human_capital_investment_index"]) +
        0.14 * df["urbanization_pressure_index"] +
        0.12 * (1 - df["infrastructure_capacity_index"]) +
        0.14 * df["ecological_throughput_pressure_index"] +
        0.10 * (1 - df["governance_capacity_index"])
    ).clip(lower=0, upper=1)

    df["demographic_opportunity_score"] = (
        0.20 * df["working_age_share_index"] +
        0.20 * df["labor_absorption_capacity_index"] +
        0.18 * df["human_capital_investment_index"] +
        0.14 * df["infrastructure_capacity_index"] +
        0.14 * df["governance_capacity_index"] +
        0.14 * df["demographic_transition_alignment_index"]
    ).clip(lower=0, upper=1)

    df["demographic_development_risk_score"] = (
        0.50 * df["demographic_pressure_score"] +
        0.30 * (1 - df["demographic_opportunity_score"]) +
        0.20 * df["ecological_throughput_pressure_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["demographic_development_risk_score"] >= 0.80,
            df["demographic_development_risk_score"] >= 0.60,
            df["demographic_development_risk_score"] >= 0.40,
        ],
        [
            "Extreme demographic-development risk",
            "High demographic-development risk",
            "Moderate demographic-development risk",
        ],
        default="Lower demographic-development risk",
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
