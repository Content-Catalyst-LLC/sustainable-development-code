from __future__ import annotations

import pandas as pd

INPUT_FILE = "legal_exclusion_panel.csv"
OUTPUT_FILE = "exclusion_accountability_and_enforceability_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "territory_name",
        "legal_domain",
        "rights_protection_index",
        "access_to_justice_index",
        "administrative_review_index",
        "enforcement_capacity_index",
        "legal_exclusion_risk_index",
        "procedural_participation_index",
        "non_discrimination_protection_index",
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

    df["justice_access_score"] = (
        0.35 * df["access_to_justice_index"] +
        0.25 * df["administrative_review_index"] +
        0.20 * df["procedural_participation_index"] +
        0.20 * df["enforcement_capacity_index"]
    ).clip(0, 1)

    df["equality_protection_score"] = (
        0.50 * df["non_discrimination_protection_index"] +
        0.50 * df["rights_protection_index"]
    ).clip(0, 1)

    df["legal_fragility_score"] = (
        0.50 * df["legal_exclusion_risk_index"] +
        0.25 * (1 - df["enforcement_capacity_index"]) +
        0.25 * (1 - df["access_to_justice_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Exclusion, accountability, and enforceability diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
