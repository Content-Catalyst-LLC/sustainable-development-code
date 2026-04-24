from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "anthropocene_planetary_boundaries_panel.csv"
OUTPUT_FILE = "anthropocene_planetary_boundaries_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "climate_forcing_index",
        "biosphere_integrity_stress_index",
        "land_system_change_index",
        "freshwater_change_index",
        "biogeochemical_disruption_index",
        "novel_entities_pressure_index",
        "ocean_acidification_pressure_index",
        "governance_response_capacity_index",
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

    df["earth_system_pressure_score"] = (
        0.16 * df["climate_forcing_index"] +
        0.16 * df["biosphere_integrity_stress_index"] +
        0.12 * df["land_system_change_index"] +
        0.12 * df["freshwater_change_index"] +
        0.14 * df["biogeochemical_disruption_index"] +
        0.16 * df["novel_entities_pressure_index"] +
        0.14 * df["ocean_acidification_pressure_index"]
    ).clip(lower=0, upper=1)

    df["planetary_governance_capacity_score"] = (
        0.32 * df["governance_response_capacity_index"] +
        0.28 * df["sustainable_development_alignment_index"] +
        0.20 * (1 - df["climate_forcing_index"]) +
        0.20 * (1 - df["biosphere_integrity_stress_index"])
    ).clip(lower=0, upper=1)

    df["planetary_boundary_risk_score"] = (
        0.55 * df["earth_system_pressure_score"] +
        0.25 * (1 - df["planetary_governance_capacity_score"]) +
        0.20 * df["ocean_acidification_pressure_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["planetary_boundary_risk_score"] >= 0.80,
            df["planetary_boundary_risk_score"] >= 0.60,
            df["planetary_boundary_risk_score"] >= 0.40,
        ],
        [
            "Extreme planetary-boundary risk",
            "High planetary-boundary risk",
            "Moderate planetary-boundary risk",
        ],
        default="Lower planetary-boundary risk",
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
