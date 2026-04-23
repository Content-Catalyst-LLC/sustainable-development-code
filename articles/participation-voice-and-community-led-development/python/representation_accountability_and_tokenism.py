from __future__ import annotations

import pandas as pd

INPUT_FILE = "participation_risk_panel.csv"
OUTPUT_FILE = "representation_accountability_and_tokenism_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "territory_name",
        "program_domain",
        "representation_quality_index",
        "accountability_channel_index",
        "feedback_closure_index",
        "elite_capture_risk_index",
        "tokenism_risk_index",
        "women_inclusion_index",
        "youth_inclusion_index",
        "disability_inclusion_index",
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

    df["representation_inclusion_score"] = (
        0.30 * df["representation_quality_index"] +
        0.20 * df["women_inclusion_index"] +
        0.20 * df["youth_inclusion_index"] +
        0.20 * df["disability_inclusion_index"] +
        0.10 * df["feedback_closure_index"]
    ).clip(0, 1)

    df["accountability_responsiveness_score"] = (
        0.40 * df["accountability_channel_index"] +
        0.35 * df["feedback_closure_index"] +
        0.25 * df["representation_quality_index"]
    ).clip(0, 1)

    df["participatory_failure_risk_score"] = (
        0.40 * df["tokenism_risk_index"] +
        0.35 * df["elite_capture_risk_index"] +
        0.25 * (1 - df["representation_quality_index"])
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Representation, accountability, and tokenism diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
