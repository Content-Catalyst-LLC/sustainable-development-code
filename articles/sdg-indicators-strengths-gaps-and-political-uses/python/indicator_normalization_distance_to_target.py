from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "sdg_indicator_values.csv"
OUTPUT_FILE = "sdg_distance_to_target_scores.csv"
COUNTRY_SUMMARY_FILE = "sdg_country_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load SDG indicator values and metadata from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "goal",
        "indicator_code",
        "indicator_name",
        "actual_value",
        "target_value",
        "direction",
        "lower_bound",
        "upper_bound",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_direction(df: pd.DataFrame) -> pd.DataFrame:
    """Validate indicator direction values."""
    valid_directions = {"higher_better", "lower_better"}

    invalid_rows = ~df["direction"].isin(valid_directions)
    if invalid_rows.any():
        invalid_values = df.loc[invalid_rows, "direction"].unique().tolist()
        raise ValueError(f"Invalid direction values found: {invalid_values}")

    return df


def normalize_indicator(row: pd.Series) -> float:
    """
    Normalize an indicator into a 0-1 scale using lower and upper bounds.
    This makes indicators more comparable before distance-to-target scoring.
    """
    lower = row["lower_bound"]
    upper = row["upper_bound"]
    value = row["actual_value"]

    if upper <= lower:
        raise ValueError(
            f"Invalid bounds for indicator {row['indicator_code']}: upper must exceed lower."
        )

    normalized = (value - lower) / (upper - lower)
    return float(np.clip(normalized, 0, 1))


def compute_distance_to_target(row: pd.Series) -> float:
    """
    Compute normalized distance to target.
    Lower values indicate better performance (closer to target).
    """
    actual = row["actual_value"]
    target = row["target_value"]
    lower = row["lower_bound"]
    upper = row["upper_bound"]

    scale = upper - lower
    if scale <= 0:
        raise ValueError(
            f"Invalid scale for indicator {row['indicator_code']}: upper must exceed lower."
        )

    if row["direction"] == "higher_better":
        distance = max(0, target - actual) / scale
    else:
        distance = max(0, actual - target) / scale

    return float(np.clip(distance, 0, 1))


def build_scores(df: pd.DataFrame) -> pd.DataFrame:
    """Compute normalized values and distance-to-target scores."""
    df = df.copy()

    df["normalized_value"] = df.apply(normalize_indicator, axis=1)
    df["distance_to_target"] = df.apply(compute_distance_to_target, axis=1)
    df["target_attained"] = df["distance_to_target"] == 0

    df["performance_band"] = np.select(
        [
            df["distance_to_target"] <= 0.10,
            df["distance_to_target"] <= 0.25,
            df["distance_to_target"] <= 0.50,
        ],
        [
            "Near target",
            "Moderate gap",
            "Large gap",
        ],
        default="Severe gap",
    )

    return df


def summarise_by_goal(df: pd.DataFrame) -> pd.DataFrame:
    """Summarize distance-to-target scores at the goal level."""
    summary = (
        df.groupby(["country", "goal"], dropna=False)
        .agg(
            indicators_reported=("indicator_code", "count"),
            avg_normalized_value=("normalized_value", "mean"),
            avg_distance_to_target=("distance_to_target", "mean"),
            target_attainment_rate=("target_attained", "mean"),
        )
        .reset_index()
    )

    summary["goal_performance_band"] = np.select(
        [
            summary["avg_distance_to_target"] <= 0.10,
            summary["avg_distance_to_target"] <= 0.25,
            summary["avg_distance_to_target"] <= 0.50,
        ],
        [
            "Near target",
            "Moderate gap",
            "Large gap",
        ],
        default="Severe gap",
    )

    summary = summary.sort_values(
        by=["country", "avg_distance_to_target"],
        ascending=[True, True],
    )

    return summary


def summarise_by_country(df: pd.DataFrame) -> pd.DataFrame:
    """Create an overall country summary across all reported goals."""
    summary = (
        df.groupby("country", dropna=False)
        .agg(
            indicators_reported=("indicator_code", "count"),
            goals_reported=("goal", "nunique"),
            avg_distance_to_target=("distance_to_target", "mean"),
            target_attainment_rate=("target_attained", "mean"),
        )
        .reset_index()
    )

    summary["overall_band"] = np.select(
        [
            summary["avg_distance_to_target"] <= 0.10,
            summary["avg_distance_to_target"] <= 0.25,
            summary["avg_distance_to_target"] <= 0.50,
        ],
        [
            "Near target",
            "Moderate gap",
            "Large gap",
        ],
        default="Severe gap",
    )

    return summary.sort_values(
        by=["avg_distance_to_target", "target_attainment_rate"],
        ascending=[True, False],
    )


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_direction(df)
    scored = build_scores(df)
    goal_summary = summarise_by_goal(scored)
    country_summary = summarise_by_country(scored)

    goal_summary.to_csv(OUTPUT_FILE, index=False)
    country_summary.to_csv(COUNTRY_SUMMARY_FILE, index=False)

    print("SDG distance-to-target scoring complete.")
    print(goal_summary.to_string(index=False))
    print("\nCountry summary:")
    print(country_summary.to_string(index=False))


if __name__ == "__main__":
    main()
