from __future__ import annotations

import itertools
import pandas as pd

SCENARIO_OUTPUT_FILE = "scenario_matrix.csv"
ROBUSTNESS_OUTPUT_FILE = "development_pathway_robustness_scores.csv"
SATISFICING_THRESHOLD = 0.60

DRIVERS = {
    "climate_path": ["moderate", "severe"],
    "trade_order": ["cooperative", "fragmented"],
    "technology_diffusion": ["broad", "concentrated"],
    "governance_capacity": ["strong", "stressed"],
}


def build_scenario_matrix(drivers: dict[str, list[str]]) -> pd.DataFrame:
    """Generate all combinations of key scenario drivers."""
    keys = list(drivers.keys())
    values = [drivers[key] for key in keys]
    rows = []

    for combination in itertools.product(*values):
        row = dict(zip(keys, combination))
        row["scenario_name"] = " / ".join(combination)
        rows.append(row)

    return pd.DataFrame(rows)


def compute_regret(df: pd.DataFrame) -> pd.DataFrame:
    """Compute regret relative to the best strategy in each scenario."""
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

    return summary.sort_values(
        by=["composite_robustness_score", "min_performance", "avg_regret"],
        ascending=[False, False, True],
    )


if __name__ == "__main__":
    # Step 1: generate a scenario matrix
    scenario_matrix = build_scenario_matrix(DRIVERS)
    scenario_matrix.to_csv(SCENARIO_OUTPUT_FILE, index=False)
    print("Scenario matrix created successfully.")
    print(scenario_matrix.to_string(index=False))

    # Step 2: example pathway scoring input
    example_df = pd.DataFrame(
        [
            ["Adaptive Infrastructure", "moderate / cooperative / broad / strong", 0.81, 0.48, 0.82, 0.67],
            ["Adaptive Infrastructure", "severe / fragmented / concentrated / stressed", 0.63, 0.48, 0.82, 0.67],
            ["Industrial Export Push", "moderate / cooperative / broad / strong", 0.78, 0.61, 0.33, 0.39],
            ["Industrial Export Push", "severe / fragmented / concentrated / stressed", 0.42, 0.61, 0.33, 0.39],
        ],
        columns=[
            "strategy_name",
            "scenario_name",
            "performance_score",
            "cost_score",
            "adaptability_score",
            "equity_score",
        ],
    )

    scored_df = compute_regret(example_df)
    summary_df = summarise_strategies(scored_df)
    summary_df.to_csv(ROBUSTNESS_OUTPUT_FILE, index=False)

    print("\nRobustness scoring complete.")
    print(summary_df.to_string(index=False))
