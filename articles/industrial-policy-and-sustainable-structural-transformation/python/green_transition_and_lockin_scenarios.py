from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "green_industrial_transition_data.csv"
OUTPUT_FILE = "green_transition_and_lockin_summary.csv"
SCENARIO_OUTPUT_FILE = "green_transition_and_lockin_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "sector",
        "energy_transition_index",
        "critical_input_dependency_index",
        "standards_alignment_index",
        "innovation_support_index",
        "export_concentration_index",
        "regional_exposure_index",
        "worker_transition_support_index",
        "supply_chain_resilience_index",
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

    df["green_transition_capacity_score"] = (
        0.25 * df["energy_transition_index"] +
        0.20 * df["innovation_support_index"] +
        0.20 * df["standards_alignment_index"] +
        0.20 * df["worker_transition_support_index"] +
        0.15 * df["supply_chain_resilience_index"]
    ).clip(0, 1)

    df["industrial_lock_in_risk_score"] = (
        0.30 * df["critical_input_dependency_index"] +
        0.25 * df["export_concentration_index"] +
        0.25 * df["regional_exposure_index"] +
        0.20 * (1 - df["standards_alignment_index"])
    ).clip(0, 1)

    df["strategic_repositioning_score"] = (
        0.50 * df["green_transition_capacity_score"] +
        0.20 * df["supply_chain_resilience_index"] +
        0.20 * df["worker_transition_support_index"] +
        0.10 * (1 - df["industrial_lock_in_risk_score"])
    ).clip(0, 1)

    return df


def build_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(
            name: str,
            energy_add: float,
            innovation_add: float,
            dependency_add: float,
            worker_add: float
        ):
            r = base.copy()
            r["scenario"] = name
            r["energy_transition_index"] = min(1.0, max(0.0, r["energy_transition_index"] + energy_add))
            r["innovation_support_index"] = min(1.0, max(0.0, r["innovation_support_index"] + innovation_add))
            r["critical_input_dependency_index"] = min(1.0, max(0.0, r["critical_input_dependency_index"] + dependency_add))
            r["worker_transition_support_index"] = min(1.0, max(0.0, r["worker_transition_support_index"] + worker_add))
            scenarios.append(r)

        scenario_record("baseline", 0.00, 0.00, 0.00, 0.00)
        scenario_record("policy_push", 0.15, 0.20, -0.05, 0.15)
        scenario_record("supply_shock", -0.05, -0.05, 0.20, -0.10)
        scenario_record("just_transition_boost", 0.05, 0.05, 0.00, 0.25)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_scores(scenario_df)

    return scenario_df[
        [
            "country",
            "sector",
            "scenario",
            "green_transition_capacity_score",
            "industrial_lock_in_risk_score",
            "strategic_repositioning_score",
        ]
    ].sort_values(by=["country", "sector", "scenario"])


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    scenarios = build_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Green transition and lock-in diagnostics complete.")
    print(summary.to_string(index=False))
    print("\nScenario results:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
