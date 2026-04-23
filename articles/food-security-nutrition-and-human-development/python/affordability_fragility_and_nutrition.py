from __future__ import annotations

import pandas as pd

INPUT_FILE = "food_governance_panel.csv"
OUTPUT_FILE = "affordability_fragility_and_nutrition_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "food_access_index",
        "healthy_diet_affordability_stress_index",
        "nutrition_quality_index",
        "price_volatility_index",
        "food_system_fragility_index",
        "governance_capacity_index",
        "nutrition_transition_readiness_index",
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

    df["affordability_gap_score"] = (
        0.40 * df["healthy_diet_affordability_stress_index"] +
        0.20 * df["price_volatility_index"] +
        0.20 * (1 - df["food_access_index"]) +
        0.20 * (1 - df["nutrition_quality_index"])
    ).clip(0, 1)

    df["food_system_fragility_score"] = (
        0.35 * df["food_system_fragility_index"] +
        0.25 * df["price_volatility_index"] +
        0.20 * (1 - df["governance_capacity_index"]) +
        0.20 * (1 - df["nutrition_transition_readiness_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Affordability, fragility, and nutrition diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
