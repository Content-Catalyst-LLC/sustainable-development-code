from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "interoperability_resilience_panel.csv"
OUTPUT_FILE = "interoperability_resilience_summary.csv"
SCENARIO_OUTPUT_FILE = "interoperability_resilience_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "platform_domain",
        "interoperability_index",
        "registry_integrity_index",
        "uptime_resilience_index",
        "cybersecurity_index",
        "vendor_dependency_index",
        "open_standards_index",
        "institutional_redundancy_index",
        "trust_recovery_index",
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

    df["interoperability_strength_score"] = (
        0.30 * df["interoperability_index"] +
        0.25 * df["open_standards_index"] +
        0.20 * df["registry_integrity_index"] +
        0.25 * df["institutional_redundancy_index"]
    ).clip(0, 1)

    df["resilience_score"] = (
        0.30 * df["uptime_resilience_index"] +
        0.25 * df["cybersecurity_index"] +
        0.20 * df["institutional_redundancy_index"] +
        0.25 * df["trust_recovery_index"]
    ).clip(0, 1)

    df["lock_in_risk_score"] = (
        0.40 * df["vendor_dependency_index"] +
        0.25 * (1 - df["open_standards_index"]) +
        0.20 * (1 - df["interoperability_index"]) +
        0.15 * (1 - df["institutional_redundancy_index"])
    ).clip(0, 1)

    df["operational_robustness_score"] = (
        0.45 * df["interoperability_strength_score"] +
        0.35 * df["resilience_score"] +
        0.20 * (1 - df["lock_in_risk_score"])
    ).clip(0, 1)

    return df


def build_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(
            name: str,
            interop_add: float,
            open_std_add: float,
            dependency_add: float,
            resilience_add: float
        ):
            r = base.copy()
            r["scenario"] = name
            r["interoperability_index"] = min(1.0, max(0.0, r["interoperability_index"] + interop_add))
            r["open_standards_index"] = min(1.0, max(0.0, r["open_standards_index"] + open_std_add))
            r["vendor_dependency_index"] = min(1.0, max(0.0, r["vendor_dependency_index"] + dependency_add))
            r["uptime_resilience_index"] = min(1.0, max(0.0, r["uptime_resilience_index"] + resilience_add))
            scenarios.append(r)

        scenario_record("baseline", 0.00, 0.00, 0.00, 0.00)
        scenario_record("standards_upgrade", 0.15, 0.20, -0.10, 0.05)
        scenario_record("vendor_lockin_worsens", -0.05, -0.10, 0.20, -0.05)
        scenario_record("resilience_investment", 0.05, 0.05, 0.00, 0.20)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_scores(scenario_df)

    return scenario_df[
        [
            "country",
            "platform_domain",
            "scenario",
            "interoperability_strength_score",
            "resilience_score",
            "lock_in_risk_score",
            "operational_robustness_score",
        ]
    ].sort_values(by=["country", "platform_domain", "scenario"])


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    scenarios = build_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Interoperability, resilience, and lock-in diagnostics complete.")
    print(summary.to_string(index=False))
    print("\nScenario results:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
