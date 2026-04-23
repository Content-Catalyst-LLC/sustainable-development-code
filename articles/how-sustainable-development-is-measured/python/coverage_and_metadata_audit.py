from __future__ import annotations

import pandas as pd

INPUT_FILE = "development_measurement_indicators.csv"
OUTPUT_FILE = "indicator_coverage_and_metadata_audit.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "goal",
        "indicator_code",
        "actual_value",
        "source_name",
        "metadata_version",
        "reporting_year",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def build_audit(df: pd.DataFrame) -> pd.DataFrame:
    audit = (
        df.assign(
            is_reported=df["actual_value"].notna(),
            has_source=df["source_name"].notna() & (df["source_name"] != ""),
            has_metadata=df["metadata_version"].notna() & (df["metadata_version"] != ""),
        )
        .groupby(["country", "goal"], dropna=False)
        .agg(
            indicators_expected=("indicator_code", "count"),
            indicators_reported=("is_reported", "sum"),
            indicators_with_source=("has_source", "sum"),
            indicators_with_metadata=("has_metadata", "sum"),
            latest_reporting_year=("reporting_year", "max"),
        )
        .reset_index()
    )

    audit["coverage_rate"] = audit["indicators_reported"] / audit["indicators_expected"]
    audit["source_completeness_rate"] = audit["indicators_with_source"] / audit["indicators_expected"]
    audit["metadata_completeness_rate"] = audit["indicators_with_metadata"] / audit["indicators_expected"]

    audit["coverage_band"] = pd.cut(
        audit["coverage_rate"],
        bins=[-0.01, 0.25, 0.50, 0.75, 1.0],
        labels=["Very low coverage", "Low coverage", "Moderate coverage", "High coverage"],
    )

    return audit.sort_values(
        by=["coverage_rate", "metadata_completeness_rate", "country", "goal"],
        ascending=[True, True, True, True],
    )


def main() -> None:
    df = load_data(INPUT_FILE)
    audit = build_audit(df)
    audit.to_csv(OUTPUT_FILE, index=False)

    print("Coverage and metadata audit complete.")
    print(audit.to_string(index=False))


if __name__ == "__main__":
    main()
