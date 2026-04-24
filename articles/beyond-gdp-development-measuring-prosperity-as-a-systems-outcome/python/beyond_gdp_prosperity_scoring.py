from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "beyond_gdp_development_panel.csv"
OUTPUT_FILE = "beyond_gdp_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "gdp_growth_index",
        "health_capability_index",
        "education_capability_index",
        "institutional_quality_index",
        "ecological_stability_index",
        "inequality_pressure_index",
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

    df["systems_prosperity_score"] = (
        0.22 * df["gdp_growth_index"] +
        0.18 * df["health_capability_index"] +
        0.18 * df["education_capability_index"] +
        0.18 * df["institutional_quality_index"] +
        0.16 * df["ecological_stability_index"] +
        0.08 * (1 - df["inequality_pressure_index"])
    ).clip(lower=0, upper=1)

    df["gdp_only_score"] = df["gdp_growth_index"]

    df["metric_distortion_gap"] = (
        df["gdp_only_score"] - df["systems_prosperity_score"]
    )

    df["distortion_band"] = np.select(
        [
            df["metric_distortion_gap"] >= 0.30,
            df["metric_distortion_gap"] >= 0.15,
            df["metric_distortion_gap"] >= 0.05,
        ],
        [
            "Severe GDP overstatement",
            "High GDP overstatement",
            "Moderate GDP overstatement",
        ],
        default="Low GDP overstatement",
    )

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    scored.to_csv(OUTPUT_FILE, index=False)
    print("Beyond GDP prosperity scoring complete.")
    print(scored.to_string(index=False))


if __name__ == "__main__":
    main()
