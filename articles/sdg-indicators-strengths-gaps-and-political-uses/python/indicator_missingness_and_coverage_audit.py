from __future__ import annotations

import pandas as pd

INPUT_FILE = "sdg_indicator_values.csv"
OUTPUT_FILE = "sdg_coverage_audit.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "goal",
        "indicator_code",
        "actual_value",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def build_coverage_audit(df: pd.DataFrame) -> pd.DataFrame:
    audit = (
        df.assign(is_reported=df["actual_value"].notna())
        .groupby(["country", "goal"], dropna=False)
        .agg(
            indicators_expected=("indicator_code", "count"),
            indicators_reported=("is_reported", "sum"),
        )
        .reset_index()
    )

    audit["coverage_rate"] = (
        audit["indicators_reported"] / audit["indicators_expected"]
    )

    audit["coverage_band"] = pd.cut(
        audit["coverage_rate"],
        bins=[-0.01, 0.25, 0.50, 0.75, 1.0],
        labels=["Very low coverage", "Low coverage", "Moderate coverage", "High coverage"],
    )

    return audit.sort_values(
        by=["coverage_rate", "country", "goal"],
        ascending=[True, True, True],
    )


def main() -> None:
    df = load_data(INPUT_FILE)
    audit = build_coverage_audit(df)
    audit.to_csv(OUTPUT_FILE, index=False)

    print("Coverage audit complete.")
    print(audit.to_string(index=False))


if __name__ == "__main__":
    main()
