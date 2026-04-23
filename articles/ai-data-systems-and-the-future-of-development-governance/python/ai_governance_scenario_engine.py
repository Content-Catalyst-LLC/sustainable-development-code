from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "ai_governance_projects.csv"
OUTPUT_FILE = "ai_governance_project_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load AI governance assessment data."""
    df = pd.read_csv(path)

    required_columns = [
        "project_name",
        "sector",
        "country",
        "data_quality_index",
        "institutional_capacity_index",
        "compute_infrastructure_index",
        "algorithmic_capability_index",
        "equity_accountability_index",
        "interoperability_index",
        "bias_risk_index",
        "opacity_risk_index",
        "surveillance_risk_index",
        "vendor_lockin_risk_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure index columns are between 0 and 1."""
    index_columns = [
        "data_quality_index",
        "institutional_capacity_index",
        "compute_infrastructure_index",
        "algorithmic_capability_index",
        "equity_accountability_index",
        "interoperability_index",
        "bias_risk_index",
        "opacity_risk_index",
        "surveillance_risk_index",
        "vendor_lockin_risk_index",
    ]

    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_readiness_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute readiness based on governance foundations."""
    df["readiness_score"] = (
        0.22 * df["data_quality_index"]
        + 0.22 * df["institutional_capacity_index"]
        + 0.14 * df["compute_infrastructure_index"]
        + 0.16 * df["algorithmic_capability_index"]
        + 0.14 * df["equity_accountability_index"]
        + 0.12 * df["interoperability_index"]
    )
    return df


def compute_risk_score(df: pd.DataFrame) -> pd.DataFrame:
    """Compute governance risk score."""
    df["governance_risk_score"] = (
        0.30 * df["bias_risk_index"]
        + 0.25 * df["opacity_risk_index"]
        + 0.25 * df["surveillance_risk_index"]
        + 0.20 * df["vendor_lockin_risk_index"]
    )
    return df


def compute_net_public_value(df: pd.DataFrame) -> pd.DataFrame:
    """Estimate net public value after governance risk penalty."""
    df["net_public_value_score"] = df["readiness_score"] - (0.50 * df["governance_risk_score"])
    return df


def assign_recommendations(df: pd.DataFrame) -> pd.DataFrame:
    """Assign deployment recommendations."""
    df["deployment_recommendation"] = np.select(
        [
            (df["net_public_value_score"] >= 0.70) & (df["institutional_capacity_index"] >= 0.65),
            (df["net_public_value_score"] >= 0.50) & (df["institutional_capacity_index"] >= 0.50),
            (df["net_public_value_score"] >= 0.35),
        ],
        [
            "Proceed with safeguards",
            "Pilot with oversight",
            "Do not scale yet",
        ],
        default="Do not deploy",
    )

    df["high_priority_review_flag"] = np.where(
        (df["surveillance_risk_index"] >= 0.60) | (df["opacity_risk_index"] >= 0.60),
        "Executive review required",
        "Standard review",
    )
    return df


def build_summary_tables(df: pd.DataFrame) -> tuple[pd.DataFrame, pd.DataFrame]:
    """Build detailed project and sector summaries."""
    project_summary = df[
        [
            "project_name",
            "sector",
            "country",
            "readiness_score",
            "governance_risk_score",
            "net_public_value_score",
            "deployment_recommendation",
            "high_priority_review_flag",
        ]
    ].copy()

    project_summary = project_summary.sort_values(
        by=["net_public_value_score", "readiness_score"],
        ascending=[False, False],
    )

    sector_summary = (
        df.groupby("sector", dropna=False)
        .agg(
            avg_readiness_score=("readiness_score", "mean"),
            avg_governance_risk_score=("governance_risk_score", "mean"),
            avg_net_public_value_score=("net_public_value_score", "mean"),
            projects=("project_name", "count"),
        )
        .reset_index()
        .sort_values(by="avg_net_public_value_score", ascending=False)
    )

    return project_summary, sector_summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    df = compute_readiness_score(df)
    df = compute_risk_score(df)
    df = compute_net_public_value(df)
    df = assign_recommendations(df)

    project_summary, sector_summary = build_summary_tables(df)

    project_summary.to_csv(OUTPUT_FILE, index=False)
    sector_summary.to_csv("ai_governance_sector_summary.csv", index=False)

    print("AI governance scenario analysis complete.")
    print("\nTop projects by net public value:\n")
    print(project_summary.head(10).to_string(index=False))
    print("\nSector summary:\n")
    print(sector_summary.to_string(index=False))


if __name__ == "__main__":
    main()
