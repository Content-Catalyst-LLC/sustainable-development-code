from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "blended_finance_project_data.csv"
OUTPUT_FILE = "blended_finance_derisking_summary.csv"
SCENARIO_OUTPUT_FILE = "blended_finance_derisking_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "project_id",
        "country",
        "sector",
        "project_size_usd",
        "base_private_share",
        "public_anchor_share",
        "guarantee_strength_index",
        "policy_stability_index",
        "currency_risk_index",
        "climate_vulnerability_index",
        "social_inclusion_index",
        "expected_development_additionality_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_shares_and_indices(df: pd.DataFrame) -> pd.DataFrame:
    for col in ["base_private_share", "public_anchor_share"]:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    index_columns = [c for c in df.columns if c.endswith("_index")]
    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")

    return df


def compute_leverage(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["risk_drag_index"] = (
        0.35 * df["currency_risk_index"] +
        0.35 * df["climate_vulnerability_index"] +
        0.30 * (1 - df["policy_stability_index"])
    ).clip(lower=0, upper=1)

    df["effective_private_mobilization_index"] = (
        0.40 * df["base_private_share"] +
        0.30 * df["guarantee_strength_index"] +
        0.20 * df["policy_stability_index"] -
        0.10 * df["risk_drag_index"]
    ).clip(lower=0, upper=1)

    df["development_alignment_score"] = (
        0.45 * df["expected_development_additionality_index"] +
        0.30 * df["social_inclusion_index"] +
        0.25 * (1 - df["risk_drag_index"])
    ).clip(lower=0, upper=1)

    df["blended_finance_quality_score"] = (
        0.35 * df["effective_private_mobilization_index"] +
        0.35 * df["development_alignment_score"] +
        0.30 * df["public_anchor_share"]
    ).clip(lower=0, upper=1)

    return df


def build_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(
            name: str,
            guarantee_add: float,
            policy_add: float,
            currency_add: float,
            climate_add: float
        ):
            r = base.copy()
            r["scenario"] = name
            r["guarantee_strength_index"] = min(1.0, r["guarantee_strength_index"] + guarantee_add)
            r["policy_stability_index"] = min(1.0, r["policy_stability_index"] + policy_add)
            r["currency_risk_index"] = min(1.0, max(0.0, r["currency_risk_index"] + currency_add))
            r["climate_vulnerability_index"] = min(1.0, max(0.0, r["climate_vulnerability_index"] + climate_add))
            scenarios.append(r)

        scenario_record("baseline", 0.00, 0.00, 0.00, 0.00)
        scenario_record("stronger_guarantee", 0.20, 0.00, 0.00, 0.00)
        scenario_record("policy_reform", 0.00, 0.20, 0.00, 0.00)
        scenario_record("fx_shock", 0.00, -0.10, 0.20, 0.00)
        scenario_record("climate_shock", 0.00, -0.05, 0.00, 0.15)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_leverage(scenario_df)

    return scenario_df[
        [
            "project_id",
            "country",
            "sector",
            "scenario",
            "effective_private_mobilization_index",
            "development_alignment_score",
            "blended_finance_quality_score",
        ]
    ].sort_values(by=["project_id", "scenario"])


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_shares_and_indices(df)
    summary = compute_leverage(df)
    scenarios = build_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Blended finance and de-risking diagnostics complete.")
    print(summary.to_string(index=False))
    print("\nScenario results:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
