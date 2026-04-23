from __future__ import annotations

import pandas as pd

INPUT_FILE = "inclusion_governance_panel.csv"
OUTPUT_FILE = "capability_gap_and_institutional_access_summary.csv"


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
        "institutional_capture_index",
        "governance_capacity_index",
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

    df["capability_gap_score"] = (
        0.25 * (1 - df["education_access_index"]) +
        0.25 * (1 - df["health_access_index"]) +
        0.25 * (1 - df["income_security_index"]) +
        0.25 * (1 - df["public_goods_access_index"])
    ).clip(0, 1)

    df["institutional_access_score"] = (
        0.40 * df["opportunity_blockage_index"] +
        0.35 * df["institutional_capture_index"] +
        0.25 * (1 - df["governance_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Capability-gap and institutional-access diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
