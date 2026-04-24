from __future__ import annotations

import pandas as pd

INPUT_FILE = "tinyml_endpoint_energy_panel.csv"
OUTPUT_FILE = "tinyml_endpoint_energy_results.csv"

# Expected columns:
# device_name, active_current_ma, sleep_current_ua,
# active_time_ms, wakeups_per_hour, battery_capacity_mah,
# inference_trigger_rate, radio_tx_cost_factor

def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required = [
        "device_name",
        "active_current_ma",
        "sleep_current_ua",
        "active_time_ms",
        "wakeups_per_hour",
        "battery_capacity_mah",
        "inference_trigger_rate",
        "radio_tx_cost_factor",
    ]

    missing = [col for col in required if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def compute_metrics(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["sleep_current_ma"] = df["sleep_current_ua"] / 1000.0
    df["active_hours_per_hour"] = (df["active_time_ms"] / 1000.0 / 3600.0) * df["wakeups_per_hour"]
    df["sleep_hours_per_hour"] = 1.0 - df["active_hours_per_hour"]

    df["average_current_ma"] = (
        df["active_current_ma"] * df["active_hours_per_hour"] +
        df["sleep_current_ma"] * df["sleep_hours_per_hour"]
    )

    df["battery_life_hours"] = df["battery_capacity_mah"] / df["average_current_ma"]
    df["battery_life_days"] = df["battery_life_hours"] / 24.0

    # Proxy for uplink burden after local inference gating.
    df["escalation_burden_score"] = (
        df["wakeups_per_hour"] *
        df["inference_trigger_rate"] *
        df["radio_tx_cost_factor"]
    )

    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    results = compute_metrics(df)
    results.to_csv(OUTPUT_FILE, index=False)

    print("TinyML endpoint energy modeling complete.")
    print(results.to_string(index=False))


if __name__ == "__main__":
    main()
