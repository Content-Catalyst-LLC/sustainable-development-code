from __future__ import annotations

import pandas as pd

INPUT_FILE = "safe_operating_space_governance_panel.csv"
OUTPUT_FILE = "boundary_pressure_and_resilience_diagnostics_summary.csv"


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

    df["aggregated_boundary_pressure_score"] = (
        0.16 * df["climate_boundary_pressure_index"] +
        0.16 * df["biosphere_boundary_pressure_index"] +
        0.14 * df["land_system_pressure_index"] +
        0.14 * df["freshwater_pressure_index"] +
        0.14 * df["biogeochemical_pressure_index"] +
        0.13 * df["novel_entities_pressure_index"] +
        0.13 * df["ocean_acidification_pressure_index"]
    ).clip(0, 1)

    df["institutional_resilience_gap_score"] = (
        0.40 * df["resilience_loss_index"] +
        0.35 * df["governability_strain_index"] +
        0.25 * (1 - df["adaptation_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Boundary-pressure and resilience diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
