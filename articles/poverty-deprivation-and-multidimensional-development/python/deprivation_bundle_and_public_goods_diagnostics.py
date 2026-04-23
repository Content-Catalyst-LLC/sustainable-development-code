from __future__ import annotations

import pandas as pd

INPUT_FILE = "poverty_governance_panel.csv"
OUTPUT_FILE = "deprivation_bundle_and_public_goods_diagnostics_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "housing_deprivation_index",
        "sanitation_deprivation_index",
        "electricity_cooking_fuel_deprivation_index",
        "nutrition_deprivation_index",
        "learning_deprivation_index",
        "public_goods_access_index",
        "governance_capacity_index",
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

    df["deprivation_bundle_score"] = (
        0.20 * df["housing_deprivation_index"] +
        0.20 * df["sanitation_deprivation_index"] +
        0.20 * df["electricity_cooking_fuel_deprivation_index"] +
        0.20 * df["nutrition_deprivation_index"] +
        0.20 * df["learning_deprivation_index"]
    ).clip(0, 1)

    df["public_goods_failure_score"] = (
        0.55 * (1 - df["public_goods_access_index"]) +
        0.45 * (1 - df["governance_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Deprivation-bundle and public-goods diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
