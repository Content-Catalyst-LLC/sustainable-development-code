from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "economic_growth_to_human_development_panel.csv"
OUTPUT_FILE = "economic_growth_to_human_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "output_growth_index",
        "health_capability_index",
        "education_capability_index",
        "income_conversion_index",
        "public_goods_conversion_index",
        "distribution_constraint_index",
        "institutional_support_index",
        "ecological_durability_index",
        "agency_freedom_index",
        "human_development_alignment_index",
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

    df["growth_translation_pressure_score"] = (
        0.16 * df["output_growth_index"] +
        0.14 * (1 - df["income_conversion_index"]) +
        0.14 * (1 - df["public_goods_conversion_index"]) +
        0.14 * df["distribution_constraint_index"] +
        0.12 * (1 - df["institutional_support_index"]) +
        0.12 * (1 - df["ecological_durability_index"]) +
        0.10 * (1 - df["agency_freedom_index"]) +
        0.08 * (1 - df["human_development_alignment_index"])
    ).clip(lower=0, upper=1)

    df["capability_expansion_score"] = (
        0.22 * df["health_capability_index"] +
        0.22 * df["education_capability_index"] +
        0.18 * df["income_conversion_index"] +
        0.16 * df["public_goods_conversion_index"] +
        0.12 * df["agency_freedom_index"] +
        0.10 * df["human_development_alignment_index"]
    ).clip(lower=0, upper=1)

    df["human_development_risk_score"] = (
        0.50 * df["growth_translation_pressure_score"] +
        0.30 * (1 - df["capability_expansion_score"]) +
        0.20 * df["distribution_constraint_index"]
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["human_development_risk_score"] >= 0.80,
            df["human_development_risk_score"] >= 0.60,
            df["human_development_risk_score"] >= 0.40,
        ],
        [
            "Extreme human development risk",
            "High human development risk",
            "Moderate human development risk",
        ],
        default="Lower human development risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "growth_translation_pressure_score",
        "capability_expansion_score",
        "human_development_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "human_development_risk_score",
            "growth_translation_pressure_score",
            "capability_expansion_score",
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

    print("From economic growth to human development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
