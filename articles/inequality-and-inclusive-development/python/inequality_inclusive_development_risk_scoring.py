from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "inequality_inclusive_development_panel.csv"
OUTPUT_FILE = "inequality_inclusive_development_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "education_access_index",
        "health_access_index",
        "income_security_index",
        "public_goods_access_index",
        "opportunity_blockage_index",
        "risk_exposure_index",
        "institutional_capture_index",
        "governance_capacity_index",
        "inclusive_transition_readiness_index",
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

    df["inclusive_capability_score"] = (
        0.22 * df["education_access_index"] +
        0.22 * df["health_access_index"] +
        0.18 * df["income_security_index"] +
        0.20 * df["public_goods_access_index"] +
        0.18 * df["governance_capacity_index"]
    ).clip(lower=0, upper=1)

    df["exclusionary_inequality_score"] = (
        0.24 * df["opportunity_blockage_index"] +
        0.22 * df["risk_exposure_index"] +
        0.22 * df["institutional_capture_index"] +
        0.16 * (1 - df["income_security_index"]) +
        0.16 * (1 - df["public_goods_access_index"])
    ).clip(lower=0, upper=1)

    df["governance_readiness_score"] = (
        0.55 * df["governance_capacity_index"] +
        0.45 * df["inclusive_transition_readiness_index"]
    ).clip(lower=0, upper=1)

    df["inclusive_development_risk_score"] = (
        0.40 * df["exclusionary_inequality_score"] +
        0.25 * (1 - df["inclusive_capability_score"]) +
        0.20 * df["institutional_capture_index"] +
        0.15 * (1 - df["governance_readiness_score"])
    ).clip(lower=0, upper=1)

    df["risk_band"] = np.select(
        [
            df["inclusive_development_risk_score"] >= 0.80,
            df["inclusive_development_risk_score"] >= 0.60,
            df["inclusive_development_risk_score"] >= 0.40,
        ],
        [
            "Extreme inclusion risk",
            "High inclusion risk",
            "Moderate inclusion risk",
        ],
        default="Lower inclusion risk",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "territory_name",
        "country_or_region",
        "territory_type",
        "inclusive_capability_score",
        "exclusionary_inequality_score",
        "governance_readiness_score",
        "inclusive_development_risk_score",
        "risk_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "inclusive_development_risk_score",
            "exclusionary_inequality_score",
            "inclusive_capability_score",
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

    print("Inequality and inclusive development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
