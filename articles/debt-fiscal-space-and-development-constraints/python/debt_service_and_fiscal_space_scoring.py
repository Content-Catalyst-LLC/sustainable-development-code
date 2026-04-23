from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "sovereign_debt_fiscal_space_data.csv"
OUTPUT_FILE = "debt_fiscal_space_scores.csv"
SCENARIO_OUTPUT_FILE = "debt_fiscal_space_stress_scenarios.csv"


def load_data(path: str) -> pd.DataFrame:
    """Load sovereign debt and fiscal-space data from CSV."""
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "year",
        "public_debt_gdp_ratio",
        "external_debt_export_ratio",
        "debt_service_revenue_ratio",
        "interest_revenue_ratio",
        "gross_financing_needs_gdp_ratio",
        "avg_maturity_years",
        "share_fx_debt",
        "share_concessional_debt",
        "tax_revenue_gdp_ratio",
        "public_investment_gdp_ratio",
        "social_spending_gdp_ratio",
        "climate_vulnerability_index",
        "market_access_index",
        "growth_rate",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def bounded_scale(series: pd.Series, lower: float, upper: float, inverse: bool = False) -> pd.Series:
    """
    Convert a raw ratio or metric into a 0-1 stress or capacity score.
    Values below lower map to 0; values above upper map to 1.
    If inverse=True, higher raw values are better and therefore invert the stress mapping.
    """
    scaled = (series - lower) / (upper - lower)
    scaled = scaled.clip(lower=0, upper=1)
    return 1 - scaled if inverse else scaled


def compute_stress_components(df: pd.DataFrame) -> pd.DataFrame:
    """Create bounded stress/capacity components from raw fiscal and debt metrics."""
    df = df.copy()

    df["debt_stock_stress"] = bounded_scale(df["public_debt_gdp_ratio"], 30, 120)
    df["external_stress"] = bounded_scale(df["external_debt_export_ratio"], 50, 300)
    df["debt_service_stress"] = bounded_scale(df["debt_service_revenue_ratio"], 5, 30)
    df["interest_burden_stress"] = bounded_scale(df["interest_revenue_ratio"], 3, 20)
    df["gross_financing_stress"] = bounded_scale(df["gross_financing_needs_gdp_ratio"], 5, 25)
    df["fx_exposure_stress"] = bounded_scale(df["share_fx_debt"], 0.10, 0.80)
    df["climate_vulnerability_stress"] = bounded_scale(df["climate_vulnerability_index"], 0.20, 0.90)

    df["maturity_buffer"] = bounded_scale(df["avg_maturity_years"], 2, 12, inverse=True)
    df["concessional_buffer"] = bounded_scale(df["share_concessional_debt"], 0.05, 0.80, inverse=True)
    df["tax_capacity_buffer"] = bounded_scale(df["tax_revenue_gdp_ratio"], 8, 30, inverse=True)
    df["market_access_buffer"] = bounded_scale(df["market_access_index"], 0.10, 0.95, inverse=True)
    df["growth_buffer"] = bounded_scale(df["growth_rate"], -3, 8, inverse=True)

    return df


def compute_fiscal_space_scores(df: pd.DataFrame) -> pd.DataFrame:
    """
    Compute composite scores:
    - debt_pressure_score: burden and vulnerability side
    - fiscal_space_capacity_score: retained room to act
    - development_crowding_out_score: risk that debt squeezes public investment and social spending
    - refinancing_risk_score: short-horizon rollover and market sensitivity
    """
    df = df.copy()

    df["debt_pressure_score"] = (
        0.18 * df["debt_stock_stress"] +
        0.14 * df["external_stress"] +
        0.20 * df["debt_service_stress"] +
        0.12 * df["interest_burden_stress"] +
        0.12 * df["gross_financing_stress"] +
        0.10 * df["fx_exposure_stress"] +
        0.14 * df["climate_vulnerability_stress"]
    )

    df["fiscal_space_capacity_score"] = (
        0.20 * (1 - df["tax_capacity_buffer"]) +
        0.18 * (1 - df["market_access_buffer"]) +
        0.18 * (1 - df["maturity_buffer"]) +
        0.14 * (1 - df["concessional_buffer"]) +
        0.15 * (1 - df["growth_buffer"]) +
        0.15 * bounded_scale(df["public_investment_gdp_ratio"], 1, 10, inverse=True)
    ).clip(lower=0, upper=1)

    low_investment_stress = bounded_scale(df["public_investment_gdp_ratio"], 1, 8, inverse=True)
    low_social_spending_stress = bounded_scale(df["social_spending_gdp_ratio"], 2, 18, inverse=True)

    df["development_crowding_out_score"] = (
        0.40 * df["debt_service_stress"] +
        0.20 * df["interest_burden_stress"] +
        0.20 * low_investment_stress +
        0.20 * low_social_spending_stress
    ).clip(lower=0, upper=1)

    df["refinancing_risk_score"] = (
        0.35 * df["gross_financing_stress"] +
        0.25 * df["maturity_buffer"] +
        0.20 * df["fx_exposure_stress"] +
        0.20 * df["market_access_buffer"]
    ).clip(lower=0, upper=1)

    df["overall_constraint_score"] = (
        0.40 * df["debt_pressure_score"] +
        0.30 * df["development_crowding_out_score"] +
        0.30 * df["refinancing_risk_score"]
    ).clip(lower=0, upper=1)

    df["constraint_band"] = np.select(
        [
            df["overall_constraint_score"] >= 0.75,
            df["overall_constraint_score"] >= 0.55,
            df["overall_constraint_score"] >= 0.35,
        ],
        [
            "Severe constraint",
            "Elevated constraint",
            "Moderate constraint",
        ],
        default="Lower constraint",
    )

    return df


def build_stress_scenarios(df: pd.DataFrame) -> pd.DataFrame:
    """
    Create simple adverse scenarios:
    - rate shock: higher debt service and financing needs
    - FX shock: higher FX stress and external burden
    - climate shock: higher vulnerability and lower growth
    """
    scenarios = []

    for _, row in df.iterrows():
        base = row.to_dict()

        def scenario_record(name: str, ds_mult: float, gfn_mult: float, fx_add: float, ext_mult: float, climate_add: float, growth_add: float):
            r = base.copy()
            r["scenario"] = name
            r["debt_service_revenue_ratio"] = r["debt_service_revenue_ratio"] * ds_mult
            r["gross_financing_needs_gdp_ratio"] = r["gross_financing_needs_gdp_ratio"] * gfn_mult
            r["share_fx_debt"] = min(1.0, r["share_fx_debt"] + fx_add)
            r["external_debt_export_ratio"] = r["external_debt_export_ratio"] * ext_mult
            r["climate_vulnerability_index"] = min(1.0, r["climate_vulnerability_index"] + climate_add)
            r["growth_rate"] = r["growth_rate"] + growth_add
            scenarios.append(r)

        scenario_record("baseline", 1.00, 1.00, 0.00, 1.00, 0.00, 0.00)
        scenario_record("rate_shock", 1.20, 1.15, 0.00, 1.00, 0.00, -0.50)
        scenario_record("fx_shock", 1.10, 1.10, 0.10, 1.15, 0.00, -0.75)
        scenario_record("climate_shock", 1.05, 1.08, 0.00, 1.05, 0.10, -1.25)

    scenario_df = pd.DataFrame(scenarios)
    scenario_df = compute_stress_components(scenario_df)
    scenario_df = compute_fiscal_space_scores(scenario_df)

    return scenario_df[
        [
            "country",
            "region",
            "year",
            "scenario",
            "debt_pressure_score",
            "development_crowding_out_score",
            "refinancing_risk_score",
            "overall_constraint_score",
            "constraint_band",
        ]
    ].sort_values(by=["country", "scenario"])


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    summary_columns = [
        "country",
        "region",
        "year",
        "debt_pressure_score",
        "fiscal_space_capacity_score",
        "development_crowding_out_score",
        "refinancing_risk_score",
        "overall_constraint_score",
        "constraint_band",
    ]
    summary = df[summary_columns].copy()
    return summary.sort_values(
        by=["overall_constraint_score", "debt_pressure_score"],
        ascending=[False, False],
    )


def main() -> None:
    df = load_data(INPUT_FILE)
    df = compute_stress_components(df)
    df = compute_fiscal_space_scores(df)

    summary = build_summary(df)
    scenarios = build_stress_scenarios(df)

    summary.to_csv(OUTPUT_FILE, index=False)
    scenarios.to_csv(SCENARIO_OUTPUT_FILE, index=False)

    print("Debt and fiscal-space scoring complete.")
    print(summary.to_string(index=False))
    print("\nStress scenarios:")
    print(scenarios.to_string(index=False))


if __name__ == "__main__":
    main()
