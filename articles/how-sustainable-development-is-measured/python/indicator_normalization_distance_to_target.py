from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "development_measurement_indicators.csv"
GOAL_OUTPUT_FILE = "distance_to_target_goal_summary.csv"
COUNTRY_OUTPUT_FILE = "distance_to_target_country_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load development indicator values and metadata from CSV."""
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
        "weight",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_direction(df: pd.DataFrame) -> pd.DataFrame:
    """Validate direction values."""
    valid_directions = {"higher_better", "lower_better"}
    invalid_rows = ~df["direction"].isin(valid_directions)

    if invalid_rows.any():
        invalid_values = df.loc[invalid_rows, "direction"].unique().tolist()
        raise ValueError(f"Invalid direction values found: {invalid_values}")

    return df


def validate_bounds(df: pd.DataFrame) -> pd.DataFrame:
    """Ensure upper bounds exceed lower bounds."""
    invalid = df["upper_bound"] <= df["lower_bound"]
    if invalid.any():
        bad_codes = df.loc[invalid, "indicator_code"].tolist()
        raise ValueError(f"Invalid bounds for indicators: {bad_codes}")

    return df


def normalize_indicator(row: pd.Series) -> float:
    """Normalize an indicator into a 0-1 interval."""
    normalized = (
        (row["actual_value"] - row["lower_bound"]) /
        (row["upper_bound"] - row["lower_bound"])
    )
    return float(np.clip(normalized, 0, 1))


def compute_distance_to_target(row: pd.Series) -> float:
    """
    Compute normalized distance-to-target.
    Lower values mean closer alignment with the target.
    """
    scale = row["upper_bound"] - row["lower_bound"]

    if row["direction"] == "higher_better":
        distance = max(0, row["target_value"] - row["actual_value"]) / scale
    else:
        distance = max(0, row["actual_value"] - row["target_value"]) / scale

    return float(np.clip(distance, 0, 1))


def build_indicator_scores(df: pd.DataFrame) -> pd.DataFrame:
    """Create normalized and distance-to-target scores."""
    df = df.copy()

    df["normalized_value"] = df.apply(normalize_indicator, axis=1)
    df["distance_to_target"] = df.apply(compute_distance_to_target, axis=1)
    df["weighted_distance"] = df["distance_to_target"] * df["weight"]
    df["target_attained"] = df["distance_to_target"] == 0

    df["indicator_band"] = np.select(
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
    """Summarize scores by country and goal."""
    summary = (
        df.groupby(["country", "goal"], dropna=False)
        .agg(
            indicators_reported=("indicator_code", "count"),
            avg_normalized_value=("normalized_value", "mean"),
            avg_distance_to_target=("distance_to_target", "mean"),
            weighted_distance_to_target=("weighted_distance", "sum"),
            target_attainment_rate=("target_attained", "mean"),
        )
        .reset_index()
    )

    summary["goal_band"] = np.select(
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
        by=["country", "avg_distance_to_target"],
        ascending=[True, True],
    )


def summarise_by_country(df: pd.DataFrame) -> pd.DataFrame:
    """Summarize scores at whole-country level."""
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

    summary["country_band"] = np.select(
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
    df = validate_bounds(df)

    scored = build_indicator_scores(df)
    goal_summary = summarise_by_goal(scored)
    country_summary = summarise_by_country(scored)

    goal_summary.to_csv(GOAL_OUTPUT_FILE, index=False)
    country_summary.to_csv(COUNTRY_OUTPUT_FILE, index=False)

    print("Indicator normalization and target-distance scoring complete.")
    print(goal_summary.to_string(index=False))
    print("\nCountry summary:")
    print(country_summary.to_string(index=False))


if __name__ == "__main__":
    main()
