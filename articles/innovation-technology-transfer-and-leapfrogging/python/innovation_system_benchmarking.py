from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "innovation_system_benchmarking_data.csv"
OUTPUT_FILE = "innovation_system_benchmarking_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "research_capacity_index",
        "industry_linkage_index",
        "public_support_index",
        "startup_ecosystem_index",
        "export_complexity_index",
        "technology_diffusion_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "research_capacity_index",
        "industry_linkage_index",
        "public_support_index",
        "startup_ecosystem_index",
        "export_complexity_index",
        "technology_diffusion_index",
    ]

    for col in cols:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_ecosystem_score(df: pd.DataFrame) -> pd.DataFrame:
    df["innovation_ecosystem_score"] = (
        0.20 * df["research_capacity_index"] +
        0.20 * df["industry_linkage_index"] +
        0.15 * df["public_support_index"] +
        0.15 * df["startup_ecosystem_index"] +
        0.15 * df["export_complexity_index"] +
        0.15 * df["technology_diffusion_index"]
    )

    df["ecosystem_band"] = np.select(
        [
            df["innovation_ecosystem_score"] >= 0.75,
            df["innovation_ecosystem_score"] >= 0.55,
            df["innovation_ecosystem_score"] >= 0.35,
        ],
        [
            "High ecosystem maturity",
            "Moderate ecosystem maturity",
            "Emerging ecosystem maturity",
        ],
        default="Low ecosystem maturity",
    )

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    df = compute_ecosystem_score(df)

    df.to_csv(OUTPUT_FILE, index=False)

    print("Innovation ecosystem benchmarking complete.")
    print(df.to_string(index=False))


if __name__ == "__main__":
    main()
