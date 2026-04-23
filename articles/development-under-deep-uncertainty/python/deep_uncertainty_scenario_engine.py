from __future__ import annotations

import pandas as pd

INPUT_FILE = "development_pathway_scenarios.csv"
OUTPUT_FILE = "development_pathway_robustness_scores.csv"
SATISFICING_THRESHOLD = 0.60


def load_data(path: str) -> pd.DataFrame:
    """Load strategy-scenario performance data."""
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


def validate_scores(df: pd.DataFrame) -> pd.DataFrame:
    """Validate normalized score columns."""
    score_columns = [
        "performance_score",
        "cost_score",
        "adaptability_score",
        "equity_score",
    ]

    for col in score_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"{col} contains values outside [0, 1].")

    return df


def compute_regret(df: pd.DataFrame) -> pd.DataFrame:
    """Compute regret relative to best performer in each scenario."""
    best_by_scenario = (
        df.groupby("scenario_name", dropna=False)["performance_score"]
        .max()
        .rename("best_score")
        .reset_index()
    )

    df = df.merge(best_by_scenario, on="scenario_name", how="left")
    df["regret"] = df["best_score"] - df["performance_score"]
    return df


def summarise_strategies(df: pd.DataFrame) -> pd.DataFrame:
    """Summarize robustness characteristics for each strategy."""
    summary = (
        df.groupby("strategy_name", dropna=False)
        .agg(
            avg_performance=("performance_score", "mean"),
            min_performance=("performance_score", "min"),
            max_performance=("performance_score", "max"),
            avg_cost=("cost_score", "mean"),
            avg_adaptability=("adaptability_score", "mean"),
            avg_equity=("equity_score", "mean"),
            avg_regret=("regret", "mean"),
            max_regret=("regret", "max"),
            scenarios_tested=("scenario_name", "count"),
        )
        .reset_index()
    )

    robustness_share = (
        df.assign(meets_threshold=df["performance_score"] >= SATISFICING_THRESHOLD)
        .groupby("strategy_name", dropna=False)["meets_threshold"]
        .mean()
        .reset_index(name="robustness_share")
    )

    summary = summary.merge(robustness_share, on="strategy_name", how="left")

    summary["composite_robustness_score"] = (
        0.40 * summary["robustness_share"]
        + 0.20 * summary["min_performance"]
        + 0.20 * summary["avg_adaptability"]
        + 0.20 * summary["avg_equity"]
    )

    summary["decision_band"] = summary["composite_robustness_score"].apply(
        lambda x: "Highly robust"
        if x >= 0.75
        else "Moderately robust"
        if x >= 0.50
        else "Fragile"
    )

    summary = summary.sort_values(
        by=["composite_robustness_score", "min_performance", "avg_regret"],
        ascending=[False, False, True],
    )

    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_scores(df)
    df = compute_regret(df)
    summary = summarise_strategies(df)
    summary.to_csv(OUTPUT_FILE, index=False)

    print("Deep uncertainty scenario stress-test complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
