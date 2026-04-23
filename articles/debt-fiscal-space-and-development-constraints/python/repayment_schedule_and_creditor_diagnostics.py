from __future__ import annotations

import pandas as pd

SCHEDULE_FILE = "repayment_schedule_data.csv"
OUTPUT_FILE = "repayment_schedule_creditor_diagnostics.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)
    required_columns = [
        "country",
        "year",
        "creditor_type",
        "currency_type",
        "principal_due",
        "interest_due",
        "government_revenue",
        "export_earnings",
    ]
    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")
    return df


def build_diagnostics(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["total_service_due"] = df["principal_due"] + df["interest_due"]
    df["service_revenue_ratio"] = df["total_service_due"] / df["government_revenue"]
    df["service_export_ratio"] = df["total_service_due"] / df["export_earnings"]

    summary = (
        df.groupby(["country", "year", "creditor_type", "currency_type"], dropna=False)
        .agg(
            total_service_due=("total_service_due", "sum"),
            avg_service_revenue_ratio=("service_revenue_ratio", "mean"),
            avg_service_export_ratio=("service_export_ratio", "mean"),
        )
        .reset_index()
    )

    summary["pressure_band"] = pd.cut(
        summary["avg_service_revenue_ratio"],
        bins=[-0.01, 0.05, 0.15, 0.25, 10],
        labels=["Low pressure", "Moderate pressure", "Elevated pressure", "Severe pressure"],
    )

    return summary.sort_values(
        by=["country", "year", "avg_service_revenue_ratio"],
        ascending=[True, True, False],
    )


def main() -> None:
    df = load_data(SCHEDULE_FILE)
    diagnostics = build_diagnostics(df)
    diagnostics.to_csv(OUTPUT_FILE, index=False)

    print("Repayment schedule diagnostics complete.")
    print(diagnostics.to_string(index=False))


if __name__ == "__main__":
    main()
