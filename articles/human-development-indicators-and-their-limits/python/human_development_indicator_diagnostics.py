from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "human_development_indicators_panel.csv"
OUTPUT_FILE = "human_development_indicator_diagnostics.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "hdi_attainment_index",
        "inequality_penalty_index",
        "gender_gap_index",
        "multidimensional_poverty_index",
        "planetary_pressure_penalty_index",
        "data_quality_confidence_index",
        "subnational_variation_index",
        "security_exclusion_index",
        "indicator_coverage_index",
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

    df["headline_attainment_score"] = (
        0.45 * df["hdi_attainment_index"] +
        0.20 * df["indicator_coverage_index"] +
        0.20 * df["data_quality_confidence_index"] +
        0.15 * (1 - df["planetary_pressure_penalty_index"])
    ).clip(lower=0, upper=1)

    df["hidden_burden_score"] = (
        0.22 * df["inequality_penalty_index"] +
        0.20 * df["gender_gap_index"] +
        0.20 * df["multidimensional_poverty_index"] +
        0.18 * df["subnational_variation_index"] +
        0.20 * df["security_exclusion_index"]
    ).clip(lower=0, upper=1)

    df["interpretive_robustness_score"] = (
        0.40 * df["data_quality_confidence_index"] +
        0.35 * df["indicator_coverage_index"] +
        0.25 * (1 - df["subnational_variation_index"])
    ).clip(lower=0, upper=1)

    df["indicator_limit_risk_score"] = (
        0.40 * df["hidden_burden_score"] +
        0.25 * (1 - df["interpretive_robustness_score"]) +
        0.20 * df["planetary_pressure_penalty_index"] +
        0.15 * (1 - df["headline_attainment_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["indicator_limit_risk_score"] >= 0.80,
            df["indicator_limit_risk_score"] >= 0.60,
            df["indicator_limit_risk_score"] >= 0.40,
        ],
        [
            "Extreme indicator-limit risk",
            "High indicator-limit risk",
            "Moderate indicator-limit risk",
        ],
        default="Lower indicator-limit risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "headline_attainment_score",
        "hidden_burden_score",
        "interpretive_robustness_score",
        "indicator_limit_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "indicator_limit_risk_score",
            "hidden_burden_score",
            "headline_attainment_score",
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

    print("Human development indicator diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
