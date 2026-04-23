from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "technology_transfer_capability_data.csv"
OUTPUT_FILE = "leapfrogging_readiness_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load technology transfer and capability data from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "sector",
        "infrastructure_readiness_index",
        "skills_capacity_index",
        "institutional_capacity_index",
        "supplier_depth_index",
        "finance_access_index",
        "standards_capacity_index",
        "technology_access_index",
        "dependency_risk_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure all index fields are in the 0-1 range."""
    index_columns = [
        "infrastructure_readiness_index",
        "skills_capacity_index",
        "institutional_capacity_index",
        "supplier_depth_index",
        "finance_access_index",
        "standards_capacity_index",
        "technology_access_index",
        "dependency_risk_index",
    ]

    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_absorptive_capacity(df: pd.DataFrame) -> pd.DataFrame:
    """Compute absorptive capacity as a weighted systems score."""
    df["absorptive_capacity_score"] = (
        0.20 * df["skills_capacity_index"] +
        0.20 * df["institutional_capacity_index"] +
        0.15 * df["supplier_depth_index"] +
        0.15 * df["standards_capacity_index"] +
        0.15 * df["infrastructure_readiness_index"] +
        0.15 * df["finance_access_index"]
    )
    return df


def compute_leapfrogging_readiness(df: pd.DataFrame) -> pd.DataFrame:
    """Estimate leapfrogging readiness from access, systems capacity, and dependence risk."""
    df["leapfrogging_readiness_score"] = (
        0.35 * df["technology_access_index"] +
        0.45 * df["absorptive_capacity_score"] -
        0.20 * df["dependency_risk_index"]
    ).clip(lower=0, upper=1)

    df["readiness_band"] = np.select(
        [
            df["leapfrogging_readiness_score"] >= 0.75,
            df["leapfrogging_readiness_score"] >= 0.55,
            df["leapfrogging_readiness_score"] >= 0.35,
        ],
        [
            "High readiness",
            "Moderate readiness",
            "Constrained readiness",
        ],
        default="Low readiness",
    )

    return df


def compute_dependency_exposure(df: pd.DataFrame) -> pd.DataFrame:
    """Compute technology-dependence exposure."""
    df["technology_dependency_exposure"] = (
        0.50 * df["dependency_risk_index"] +
        0.25 * (1 - df["supplier_depth_index"]) +
        0.25 * (1 - df["standards_capacity_index"])
    ).clip(lower=0, upper=1)

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Build a summary table sorted by readiness."""
    summary_columns = [
        "country",
        "sector",
        "absorptive_capacity_score",
        "leapfrogging_readiness_score",
        "technology_dependency_exposure",
        "readiness_band",
    ]

    summary = df[summary_columns].copy()
    summary = summary.sort_values(
        by=["leapfrogging_readiness_score", "technology_dependency_exposure"],
        ascending=[False, True],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    df = compute_absorptive_capacity(df)
    df = compute_leapfrogging_readiness(df)
    df = compute_dependency_exposure(df)

    summary = build_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Leapfrogging readiness scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
