from __future__ import annotations

import pandas as pd

INPUT_FILE = "threshold_cascade_panel.csv"
OUTPUT_FILE = "cascade_resilience_and_governance_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "system_name",
        "territory_name",
        "ecosystem_type",
        "cascade_exposure_index",
        "resilience_buffer_index",
        "monitoring_readiness_index",
        "precaution_capacity_index",
        "justice_exposure_index",
        "feedback_intensity_index",
        "recovery_difficulty_index",
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

    df["resilience_governance_score"] = (
        0.35 * df["resilience_buffer_index"] +
        0.25 * df["monitoring_readiness_index"] +
        0.25 * df["precaution_capacity_index"] +
        0.15 * (1 - df["justice_exposure_index"])
    ).clip(0, 1)

    df["cascade_amplification_score"] = (
        0.40 * df["cascade_exposure_index"] +
        0.30 * df["feedback_intensity_index"] +
        0.30 * df["recovery_difficulty_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Cascade, resilience, and governance diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
