from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "policy_transition_risk_panel.csv"
OUTPUT_FILE = "feedback_delay_and_transition_summary.csv"
SCENARIO_OUTPUT_FILE = "feedback_delay_and_transition_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "policy_system",
        "feedback_visibility_index",
        "delay_management_index",
        "path_dependency_index",
        "institutional_inertia_index",
        "shock_response_index",
        "cross_scale_alignment_index",
        "resilience_readiness_index",
        "coordination_cost_index",
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

    df["system_visibility_score"] = (
        0.35 * df["feedback_visibility_index"] +
        0.25 * df["delay_management_index"] +
        0.20 * df["cross_scale_alignment_index"] +
        0.20 * df["shock_response_index"]
    ).clip(0, 1)

    df["governance_inertia_score"] = (
        0.35 * df["path_dependency_index"] +
        0.35 * df["institutional_inertia_index"] +
        0.15 * df["coordination_cost_index"] +
        0.15 * (1 - df["cross_scale_alignment_index"])
    ).clip(0, 1)

    df["transition_readiness_score"] = (
        0.35 * df["resilience_readiness_index"] +
        0.25 * df["shock_response_index"] +
        0.20 * df["system_visibility_score"] +
        0.20 * (1 - df["governance_inertia_score"])
    ).clip(0, 1)

    return df


def build_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(
            name: str,
            visibility_add: float,
            delay_add: float,
            inertia_add: float,
            readiness_add: float
        ):
            r = base.copy()
            r["scenario"] = name
            r["feedback_visibility_index"] = min(1.0, max(0.0, r["feedback_visibility_index"] + visibility_add))
            r["delay_management_index"] = min(1.0, max(0.0, r["delay_management_index"] + delay_add))
            r["institutional_inertia_index"] = min(1.0, max(0.0, r["institutional_inertia_index"] + inertia_add))
            r["resilience_readiness_index"] = min(1.0, max(0.0, r["resilience_readiness_index"] + readiness_add))
            scenarios.append(r)

        scenario_record("baseline", 0.00, 0.00, 0.00, 0.00)
        scenario_record("coordination_upgrade", 0.15, 0.15, -0.10, 0.20)
        scenario_record("fragmentation_worsens", -0.10, -0.10, 0.15, -0.10)
        scenario_record("shock_learning", 0.10, 0.05, -0.05, 0.25)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_scores(scenario_df)

    return scenario_df[
        [
            "country",
            "policy_system",
            "scenario",
            "system_visibility_score",
            "governance_inertia_score",
            "transition_readiness_score",
        ]
    ].sort_values(by=["country", "policy_system", "scenario"])


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    scenarios = build_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Feedback, delay, and transition diagnostics complete.")
    print(summary.to_string(index=False))
    print("\nScenario results:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
