from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "health_education_capability_panel.csv"
OUTPUT_FILE = "health_education_capability_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "health_access_index",
        "education_access_index",
        "service_quality_index",
        "financial_hardship_risk_index",
        "learning_deprivation_index",
        "life_course_vulnerability_index",
        "inequality_exclusion_index",
        "governance_capacity_index",
        "capability_transition_readiness_index",
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

    df["capability_expansion_score"] = (
        0.22 * df["health_access_index"] +
        0.22 * df["education_access_index"] +
        0.20 * df["service_quality_index"] +
        0.18 * df["governance_capacity_index"] +
        0.18 * df["capability_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["capability_erosion_score"] = (
        0.22 * df["financial_hardship_risk_index"] +
        0.20 * df["learning_deprivation_index"] +
        0.20 * df["life_course_vulnerability_index"] +
        0.20 * df["inequality_exclusion_index"] +
        0.18 * (1 - df["service_quality_index"])
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["capability_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["human_capability_risk_score"] = (
        0.40 * df["capability_erosion_score"] +
        0.25 * (1 - df["capability_expansion_score"]) +
        0.20 * df["financial_hardship_risk_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["human_capability_risk_score"] >= 0.80,
            df["human_capability_risk_score"] >= 0.60,
            df["human_capability_risk_score"] >= 0.40,
        ],
        [
            "Extreme capability risk",
            "High capability risk",
            "Moderate capability risk",
        ],
        default="Lower capability risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "capability_expansion_score",
        "capability_erosion_score",
        "governance_readiness_score",
        "human_capability_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "human_capability_risk_score",
            "capability_erosion_score",
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

    print("Health, education, and human capability scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
