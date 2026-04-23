from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "mobility_risk_and_affordability_panel.csv"
OUTPUT_FILE = "safety_affordability_and_lockin_summary.csv"
SCENARIO_OUTPUT_FILE = "safety_affordability_and_lockin_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "city_region",
        "territory_type",
        "fare_affordability_index",
        "gender_safety_index",
        "disability_access_index",
        "service_reliability_index",
        "peripherality_index",
        "car_dependence_risk_index",
        "active_mobility_index",
        "public_transport_integration_index",
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

    df["equity_mobility_score"] = (
        0.25 * df["fare_affordability_index"] +
        0.20 * df["gender_safety_index"] +
        0.20 * df["disability_access_index"] +
        0.20 * df["service_reliability_index"] +
        0.15 * df["public_transport_integration_index"]
    ).clip(0, 1)

    df["territorial_constraint_score"] = (
        0.35 * df["peripherality_index"] +
        0.30 * df["car_dependence_risk_index"] +
        0.20 * (1 - df["service_reliability_index"]) +
        0.15 * (1 - df["active_mobility_index"])
    ).clip(0, 1)

    df["just_transition_mobility_score"] = (
        0.30 * df["equity_mobility_score"] +
        0.25 * df["active_mobility_index"] +
        0.20 * df["public_transport_integration_index"] +
        0.25 * (1 - df["territorial_constraint_score"])
    ).clip(0, 1)

    return df


def build_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(
            name: str,
            affordability_add: float,
            safety_add: float,
            reliability_add: float,
            dependence_add: float
        ):
            r = base.copy()
            r["scenario"] = name
            r["fare_affordability_index"] = min(1.0, max(0.0, r["fare_affordability_index"] + affordability_add))
            r["gender_safety_index"] = min(1.0, max(0.0, r["gender_safety_index"] + safety_add))
            r["service_reliability_index"] = min(1.0, max(0.0, r["service_reliability_index"] + reliability_add))
            r["car_dependence_risk_index"] = min(1.0, max(0.0, r["car_dependence_risk_index"] + dependence_add))
            scenarios.append(r)

        scenario_record("baseline", 0.00, 0.00, 0.00, 0.00)
        scenario_record("transit_improvement", 0.10, 0.10, 0.15, -0.10)
        scenario_record("cost_pressure", -0.15, -0.05, -0.05, 0.10)
        scenario_record("safety_upgrade", 0.00, 0.20, 0.05, -0.05)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_scores(scenario_df)

    return scenario_df[
        [
            "city_region",
            "territory_type",
            "scenario",
            "equity_mobility_score",
            "territorial_constraint_score",
            "just_transition_mobility_score",
        ]
    ].sort_values(by=["city_region", "territory_type", "scenario"])


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    scenarios = build_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Safety, affordability, and lock-in diagnostics complete.")
    print(summary.to_string(index=False))
    print("\nScenario results:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
