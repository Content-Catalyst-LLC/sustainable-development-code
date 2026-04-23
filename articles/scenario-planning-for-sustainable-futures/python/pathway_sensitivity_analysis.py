from __future__ import annotations

import pandas as pd

INPUT_FILE = "development_pathway_scenarios.csv"
OUTPUT_FILE = "pathway_sensitivity_summary.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load pathway-scenario data."""
    df = pd.read_csv(path)

    required_columns = [
        "strategy_name",
        "scenario_name",
        "performance_score",
        "cost_score",
        "adaptability_score",
        "equity_score",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def build_sensitivity_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Summarize score volatility across scenarios."""
    summary = (
        df.groupby("strategy_name", dropna=False)
        .agg(
            performance_range=("performance_score", lambda s: s.max() - s.min()),
            cost_range=("cost_score", lambda s: s.max() - s.min()),
            adaptability_range=("adaptability_score", lambda s: s.max() - s.min()),
            equity_range=("equity_score", lambda s: s.max() - s.min()),
            scenarios_tested=("scenario_name", "count"),
        )
        .reset_index()
    )

    summary["overall_sensitivity"] = (
        0.40 * summary["performance_range"]
        + 0.20 * summary["cost_range"]
        + 0.20 * summary["adaptability_range"]
        + 0.20 * summary["equity_range"]
    )

    summary = summary.sort_values(by="overall_sensitivity", ascending=False)
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    summary = build_sensitivity_summary(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Pathway sensitivity analysis complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
