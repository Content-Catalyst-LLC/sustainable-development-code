from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "brundtland_definition_legacy_panel.csv"
OUTPUT_FILE = "brundtland_definition_legacy_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "present_need_pressure_index",
        "poverty_reduction_support_index",
        "ecological_degradation_index",
        "future_burden_transfer_index",
        "institutional_durability_index",
        "intergenerational_stewardship_index",
        "absorptive_capacity_stress_index",
        "technology_organisation_constraint_index",
        "development_legitimacy_alignment_index",
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

    df["brundtland_pressure_score"] = (
        0.16 * df["present_need_pressure_index"] +
        0.14 * (1 - df["poverty_reduction_support_index"]) +
        0.16 * df["ecological_degradation_index"] +
        0.14 * df["future_burden_transfer_index"] +
        0.12 * (1 - df["institutional_durability_index"]) +
        0.10 * (1 - df["intergenerational_stewardship_index"]) +
        0.10 * df["absorptive_capacity_stress_index"] +
        0.08 * df["technology_organisation_constraint_index"]
    ).clip(lower=0, upper=1)

    df["brundtland_capacity_score"] = (
        0.24 * df["poverty_reduction_support_index"] +
        0.20 * df["institutional_durability_index"] +
        0.20 * df["intergenerational_stewardship_index"] +
        0.18 * (1 - df["absorptive_capacity_stress_index"]) +
        0.18 * df["development_legitimacy_alignment_index"]
    ).clip(lower=0, upper=1)

    df["brundtland_legitimacy_risk_score"] = (
        0.50 * df["brundtland_pressure_score"] +
        0.30 * (1 - df["brundtland_capacity_score"]) +
        0.20 * df["future_burden_transfer_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["brundtland_legitimacy_risk_score"] >= 0.80,
            df["brundtland_legitimacy_risk_score"] >= 0.60,
            df["brundtland_legitimacy_risk_score"] >= 0.40,
        ],
        [
            "Extreme Brundtland legitimacy risk",
            "High Brundtland legitimacy risk",
            "Moderate Brundtland legitimacy risk",
        ],
        default="Lower Brundtland legitimacy risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "brundtland_pressure_score",
        "brundtland_capacity_score",
        "brundtland_legitimacy_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "brundtland_legitimacy_risk_score",
            "brundtland_pressure_score",
            "brundtland_capacity_score",
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

    print("The Brundtland definition and legacy scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
