from __future__ import annotations

import pandas as pd

INPUT_FILE = "global_governance_risk_panel.csv"
OUTPUT_FILE = "fragmentation_legitimacy_and_implementation_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country_or_regime",
        "territory_name",
        "governance_domain",
        "coordination_strength_index",
        "implementation_support_index",
        "legitimacy_index",
        "fragmentation_risk_index",
        "unequal_influence_risk_index",
        "institutional_lockin_risk_index",
        "finance_access_index",
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

    df["implementation_legitimacy_score"] = (
        0.35 * df["implementation_support_index"] +
        0.30 * df["legitimacy_index"] +
        0.20 * df["coordination_strength_index"] +
        0.15 * df["finance_access_index"]
    ).clip(0, 1)

    df["regime_complexity_score"] = (
        0.45 * df["fragmentation_risk_index"] +
        0.30 * df["unequal_influence_risk_index"] +
        0.25 * df["institutional_lockin_risk_index"]
    ).clip(0, 1)

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    summary = compute_scores(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Fragmentation, legitimacy, and implementation diagnostics complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
