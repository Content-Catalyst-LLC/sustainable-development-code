from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "four_dimensions_sustainable_development_panel.csv"
OUTPUT_FILE = "four_dimensions_sustainable_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "economic_prosperity_index",
        "social_inclusion_index",
        "environmental_sustainability_index",
        "good_governance_index",
        "inequality_pressure_index",
        "ecological_stress_index",
        "institutional_failure_index",
        "long_run_alignment_index",
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

    df["dimensional_pressure_score"] = (
        0.18 * (1 - df["economic_prosperity_index"]) +
        0.18 * (1 - df["social_inclusion_index"]) +
        0.18 * (1 - df["environmental_sustainability_index"]) +
        0.18 * (1 - df["good_governance_index"]) +
        0.10 * df["inequality_pressure_index"] +
        0.10 * df["ecological_stress_index"] +
        0.08 * df["institutional_failure_index"]
    ).clip(lower=0, upper=1)

    df["dimensional_balance_score"] = (
        0.24 * df["economic_prosperity_index"] +
        0.24 * df["social_inclusion_index"] +
        0.24 * df["environmental_sustainability_index"] +
        0.18 * df["good_governance_index"] +
        0.10 * df["long_run_alignment_index"]
    ).clip(lower=0, upper=1)

    df["four_dimensions_risk_score"] = (
        0.50 * df["dimensional_pressure_score"] +
        0.30 * (1 - df["dimensional_balance_score"]) +
        0.20 * df["institutional_failure_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["four_dimensions_risk_score"] >= 0.80,
            df["four_dimensions_risk_score"] >= 0.60,
            df["four_dimensions_risk_score"] >= 0.40,
        ],
        [
            "Extreme dimensional-fragility risk",
            "High dimensional-fragility risk",
            "Moderate dimensional-fragility risk",
        ],
        default="Lower dimensional-fragility risk",
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
