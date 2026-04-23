from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "climate_finance_allocation_data.csv"
OUTPUT_FILE = "adaptation_mitigation_finance_gap_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "adaptation_need_usd",
        "mitigation_need_usd",
        "adaptation_finance_usd",
        "mitigation_finance_usd",
        "resilience_urgency_index",
        "debt_constraint_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def compute_gaps(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["adaptation_gap_usd"] = (df["adaptation_need_usd"] - df["adaptation_finance_usd"]).clip(lower=0)
    df["mitigation_gap_usd"] = (df["mitigation_need_usd"] - df["mitigation_finance_usd"]).clip(lower=0)

    df["adaptation_coverage_ratio"] = np.where(
        df["adaptation_need_usd"] > 0,
        df["adaptation_finance_usd"] / df["adaptation_need_usd"],
        0,
    ).clip(0, 1)

    df["mitigation_coverage_ratio"] = np.where(
        df["mitigation_need_usd"] > 0,
        df["mitigation_finance_usd"] / df["mitigation_need_usd"],
        0,
    ).clip(0, 1)

    df["climate_finance_alignment_score"] = (
        0.40 * df["adaptation_coverage_ratio"] +
        0.30 * df["mitigation_coverage_ratio"] +
        0.20 * df["resilience_urgency_index"] +
        0.10 * (1 - df["debt_constraint_index"])
    ).clip(0, 1)

    df["alignment_band"] = np.select(
        [
            df["climate_finance_alignment_score"] >= 0.80,
            df["climate_finance_alignment_score"] >= 0.60,
            df["climate_finance_alignment_score"] >= 0.40,
        ],
        [
            "Strong alignment",
            "Moderate alignment",
            "Weak alignment",
        ],
        default="Severe misalignment",
    )

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    summary = compute_gaps(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Adaptation and mitigation finance-gap analysis complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
