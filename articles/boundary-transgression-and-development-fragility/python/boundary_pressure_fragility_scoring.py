from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "boundary_pressure_fragility_data.csv"
OUTPUT_FILE = "boundary_pressure_fragility_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load ecological pressure and development fragility data from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "climate_pressure_index",
        "freshwater_pressure_index",
        "biosphere_pressure_index",
        "land_system_pressure_index",
        "nutrient_pressure_index",
        "adaptive_capacity_index",
        "infrastructure_resilience_index",
        "equity_protection_index",
        "institutional_capacity_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure normalized index fields fall between 0 and 1."""
    index_columns = [
        "climate_pressure_index",
        "freshwater_pressure_index",
        "biosphere_pressure_index",
        "land_system_pressure_index",
        "nutrient_pressure_index",
        "adaptive_capacity_index",
        "infrastructure_resilience_index",
        "equity_protection_index",
        "institutional_capacity_index",
    ]

    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_boundary_pressure(df: pd.DataFrame) -> pd.DataFrame:
    """Compute a weighted aggregate boundary pressure score."""
    df["boundary_pressure_score"] = (
        0.25 * df["climate_pressure_index"]
        + 0.20 * df["freshwater_pressure_index"]
        + 0.20 * df["biosphere_pressure_index"]
        + 0.20 * df["land_system_pressure_index"]
        + 0.15 * df["nutrient_pressure_index"]
    )
    return df


def compute_capacity_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute an aggregate adaptive and institutional capacity score."""
    df["capacity_score"] = (
        0.35 * df["adaptive_capacity_index"]
        + 0.25 * df["institutional_capacity_index"]
        + 0.20 * df["infrastructure_resilience_index"]
        + 0.20 * df["equity_protection_index"]
    )
    return df


def compute_fragility_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute ecological fragility as pressure relative to capacity."""
    df["ecological_fragility_score"] = (
        0.70 * df["boundary_pressure_score"]
        - 0.50 * df["capacity_score"]
    ).clip(lower=0)

    df["pressure_capacity_gap"] = (
        df["boundary_pressure_score"] - df["capacity_score"]
    )

    df["fragility_band"] = np.select(
        [
            df["ecological_fragility_score"] >= 0.65,
            df["ecological_fragility_score"] >= 0.45,
            df["ecological_fragility_score"] >= 0.25,
        ],
        [
            "Severe fragility",
            "Elevated fragility",
            "Moderate fragility",
        ],
        default="Lower fragility",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Build a summary table sorted by fragility severity."""
    summary_columns = [
        "country",
        "region",
        "boundary_pressure_score",
        "capacity_score",
        "pressure_capacity_gap",
        "ecological_fragility_score",
        "fragility_band",
    ]

    summary = df[summary_columns].copy()
    summary = summary.sort_values(
        by=["ecological_fragility_score", "boundary_pressure_score"],
        ascending=[False, False],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    df = compute_boundary_pressure(df)
    df = compute_capacity_score(df)
    df = compute_fragility_score(df)

    summary = build_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Boundary pressure fragility scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
