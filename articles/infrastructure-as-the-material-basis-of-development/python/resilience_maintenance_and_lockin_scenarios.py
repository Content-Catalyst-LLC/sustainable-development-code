from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "infrastructure_resilience_panel.csv"
OUTPUT_FILE = "resilience_maintenance_and_lockin_summary.csv"
SCENARIO_OUTPUT_FILE = "resilience_maintenance_and_lockin_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "infrastructure_domain",
        "service_reliability_index",
        "maintenance_capacity_index",
        "inspection_quality_index",
        "climate_exposure_index",
        "redundancy_index",
        "institutional_response_index",
        "lock_in_risk_index",
        "adaptation_readiness_index",
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

    df["operational_resilience_score"] = (
        0.25 * df["service_reliability_index"] +
        0.20 * df["maintenance_capacity_index"] +
        0.15 * df["inspection_quality_index"] +
        0.20 * df["redundancy_index"] +
        0.20 * df["institutional_response_index"]
    ).clip(0, 1)

    df["climate_vulnerability_score"] = (
        0.45 * df["climate_exposure_index"] +
        0.25 * (1 - df["adaptation_readiness_index"]) +
        0.15 * (1 - df["redundancy_index"]) +
        0.15 * (1 - df["maintenance_capacity_index"])
    ).clip(0, 1)

    df["pathway_lock_in_score"] = (
        0.50 * df["lock_in_risk_index"] +
        0.25 * df["climate_exposure_index"] +
        0.25 * (1 - df["adaptation_readiness_index"])
    ).clip(0, 1)

    df["forward_viability_score"] = (
        0.40 * df["operational_resilience_score"] +
        0.30 * (1 - df["climate_vulnerability_score"]) +
        0.20 * df["adaptation_readiness_index"] +
        0.10 * (1 - df["pathway_lock_in_score"])
    ).clip(0, 1)

    return df


def build_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(
            name: str,
            maintenance_add: float,
            redundancy_add: float,
            exposure_add: float,
            adaptation_add: float
        ):
            r = base.copy()
            r["scenario"] = name
            r["maintenance_capacity_index"] = min(1.0, max(0.0, r["maintenance_capacity_index"] + maintenance_add))
            r["redundancy_index"] = min(1.0, max(0.0, r["redundancy_index"] + redundancy_add))
            r["climate_exposure_index"] = min(1.0, max(0.0, r["climate_exposure_index"] + exposure_add))
            r["adaptation_readiness_index"] = min(1.0, max(0.0, r["adaptation_readiness_index"] + adaptation_add))
            scenarios.append(r)

        scenario_record("baseline", 0.00, 0.00, 0.00, 0.00)
        scenario_record("maintenance_upgrade", 0.20, 0.05, 0.00, 0.10)
        scenario_record("climate_stress", -0.05, -0.05, 0.20, -0.10)
        scenario_record("resilience_investment", 0.10, 0.20, -0.05, 0.20)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_scores(scenario_df)

    return scenario_df[
        [
            "country",
            "infrastructure_domain",
            "scenario",
            "operational_resilience_score",
            "climate_vulnerability_score",
            "pathway_lock_in_score",
            "forward_viability_score",
        ]
    ].sort_values(by=["country", "infrastructure_domain", "scenario"])


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    scenarios = build_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Resilience, maintenance, and lock-in diagnostics complete.")
    print(summary.to_string(index=False))
    print("\nScenario results:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
