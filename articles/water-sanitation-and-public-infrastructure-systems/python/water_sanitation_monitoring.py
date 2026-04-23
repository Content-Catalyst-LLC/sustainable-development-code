from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "district_wash_data.csv"
OUTPUT_FILE = "district_wash_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load district-level WASH data from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "district",
        "population",
        "safe_water_access_rate",
        "safe_sanitation_access_rate",
        "basic_hygiene_access_rate",
        "wastewater_treatment_rate",
        "non_revenue_water_rate",
        "flood_risk_index",
        "annual_maintenance_gap_usd",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_rates(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure all rate columns are bounded between 0 and 1."""
    rate_columns = [
        "safe_water_access_rate",
        "safe_sanitation_access_rate",
        "basic_hygiene_access_rate",
        "wastewater_treatment_rate",
        "non_revenue_water_rate",
        "flood_risk_index",
    ]

    for col in rate_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_indicators(df: pd.DataFrame) -> pd.DataFrame:
    """Compute access gaps, service burden, and infrastructure stress."""
    df["people_without_safe_water"] = (
        df["population"] * (1 - df["safe_water_access_rate"])
    ).round().astype(int)

    df["people_without_safe_sanitation"] = (
        df["population"] * (1 - df["safe_sanitation_access_rate"])
    ).round().astype(int)

    df["people_without_basic_hygiene"] = (
        df["population"] * (1 - df["basic_hygiene_access_rate"])
    ).round().astype(int)

    df["combined_access_gap_score"] = (
        (
            (1 - df["safe_water_access_rate"])
            + (1 - df["safe_sanitation_access_rate"])
            + (1 - df["basic_hygiene_access_rate"])
        ) / 3
    )

    per_capita_maintenance_gap = df["annual_maintenance_gap_usd"] / df["population"]

    min_gap = per_capita_maintenance_gap.min()
    max_gap = per_capita_maintenance_gap.max()

    if max_gap == min_gap:
        normalized_maintenance_gap = pd.Series(0.0, index=df.index)
    else:
        normalized_maintenance_gap = (
            (per_capita_maintenance_gap - min_gap) / (max_gap - min_gap)
        )

    df["infrastructure_stress_score"] = (
        0.35 * df["non_revenue_water_rate"]
        + 0.35 * df["flood_risk_index"]
        + 0.30 * normalized_maintenance_gap
    )

    df["safe_management_proxy"] = (
        df["safe_sanitation_access_rate"] * df["wastewater_treatment_rate"]
    )

    df["priority_flag"] = np.where(
        (
            (df["combined_access_gap_score"] >= 0.30)
            | (df["infrastructure_stress_score"] >= 0.60)
            | (df["safe_management_proxy"] <= 0.40)
        ),
        "High Priority",
        "Standard Monitoring",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Return a concise planning summary sorted by urgency."""
    summary_columns = [
        "district",
        "population",
        "people_without_safe_water",
        "people_without_safe_sanitation",
        "people_without_basic_hygiene",
        "wastewater_treatment_rate",
        "combined_access_gap_score",
        "infrastructure_stress_score",
        "safe_management_proxy",
        "priority_flag",
    ]

    summary = df[summary_columns].copy()
    summary = summary.sort_values(
        by=["priority_flag", "combined_access_gap_score", "infrastructure_stress_score"],
        ascending=[True, False, False],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_rates(df)
    df = compute_indicators(df)
    summary = build_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("WASH performance summary created successfully.")
    print(summary.head(10).to_string(index=False))


if __name__ == "__main__":
    main()
