from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "safe_operating_space_long_run_development_panel.csv"
OUTPUT_FILE = "safe_operating_space_long_run_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "climate_boundary_pressure_index",
        "biosphere_boundary_pressure_index",
        "land_system_pressure_index",
        "freshwater_pressure_index",
        "biogeochemical_pressure_index",
        "novel_entities_pressure_index",
        "ocean_acidification_pressure_index",
        "resilience_loss_index",
        "governability_strain_index",
        "adaptation_capacity_index",
        "justice_exposure_index",
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

    df["boundary_pressure_score"] = (
        0.16 * df["climate_boundary_pressure_index"] +
        0.16 * df["biosphere_boundary_pressure_index"] +
        0.14 * df["land_system_pressure_index"] +
        0.14 * df["freshwater_pressure_index"] +
        0.14 * df["biogeochemical_pressure_index"] +
        0.13 * df["novel_entities_pressure_index"] +
        0.13 * df["ocean_acidification_pressure_index"]
    ).clip(lower=0, upper=1)

    df["long_run_viability_support_score"] = (
        0.40 * (1 - df["resilience_loss_index"]) +
        0.30 * (1 - df["governability_strain_index"]) +
        0.20 * df["adaptation_capacity_index"] +
        0.10 * (1 - df["justice_exposure_index"])
    ).clip(lower=0, upper=1)

    df["safe_operating_space_risk_score"] = (
        0.50 * df["boundary_pressure_score"] +
        0.20 * df["resilience_loss_index"] +
        0.15 * df["governability_strain_index"] +
        0.10 * (1 - df["adaptation_capacity_index"]) +
        0.05 * df["justice_exposure_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["safe_operating_space_risk_score"] >= 0.80,
            df["safe_operating_space_risk_score"] >= 0.60,
            df["safe_operating_space_risk_score"] >= 0.40,
        ],
        [
            "Extreme long-run development risk",
            "High long-run development risk",
            "Moderate long-run development risk",
        ],
        default="Lower long-run development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "boundary_pressure_score",
        "long_run_viability_support_score",
        "safe_operating_space_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "safe_operating_space_risk_score",
            "boundary_pressure_score",
            "long_run_viability_support_score",
        ],
        ascending=[False, False, True],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Safe operating space and long-run development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
