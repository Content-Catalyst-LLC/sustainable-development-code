from __future__ import annotations

import pandas as pd

INPUT_FILE = "institutional_risk_panel.csv"
OUTPUT_FILE = "fragmentation_trust_and_implementation_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "territory_name",
        "institutional_domain",
        "implementation_capacity_index",
        "trust_support_index",
        "delivery_system_reliability_index",
        "fragmentation_risk_index",
        "capture_risk_index",
        "accountability_strength_index",
        "learning_capacity_index",
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

    df["delivery_trust_score"] = (
        0.35 * df["delivery_system_reliability_index"] +
        0.30 * df["trust_support_index"] +
        0.20 * df["accountability_strength_index"] +
        0.15 * df["implementation_capacity_index"]
    ).clip(0, 1)

    df["institutional_risk_score"] = (
        0.45 * df["fragmentation_risk_index"] +
        0.35 * df["capture_risk_index"] +
        0.20 * (1 - df["learning_capacity_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Fragmentation, trust, and implementation diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
