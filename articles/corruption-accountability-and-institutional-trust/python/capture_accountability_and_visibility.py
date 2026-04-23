from __future__ import annotations

import pandas as pd

INPUT_FILE = "integrity_risk_panel.csv"
OUTPUT_FILE = "capture_accountability_and_visibility_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "territory_name",
        "institutional_domain",
        "capture_risk_index",
        "accountability_strength_index",
        "complaint_access_index",
        "beneficial_ownership_visibility_index",
        "audit_capacity_index",
        "service_integrity_index",
        "trust_support_index",
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

    df["visibility_and_accountability_score"] = (
        0.30 * df["beneficial_ownership_visibility_index"] +
        0.25 * df["audit_capacity_index"] +
        0.25 * df["accountability_strength_index"] +
        0.20 * df["complaint_access_index"]
    ).clip(0, 1)

    df["trust_and_service_integrity_score"] = (
        0.55 * df["service_integrity_index"] +
        0.45 * df["trust_support_index"]
    ).clip(0, 1)

    df["capture_exposure_score"] = (
        0.50 * df["capture_risk_index"] +
        0.25 * (1 - df["beneficial_ownership_visibility_index"]) +
        0.25 * (1 - df["accountability_strength_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Capture, accountability, and visibility diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
