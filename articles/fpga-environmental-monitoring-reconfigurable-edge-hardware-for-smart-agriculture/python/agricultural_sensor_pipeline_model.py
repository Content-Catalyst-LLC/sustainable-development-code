from __future__ import annotations

import pandas as pd

INPUT_FILE = "fpga_agriculture_sensor_panel.csv"
OUTPUT_FILE = "fpga_agriculture_sensor_pipeline_results.csv"

def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required = [
        "node_name",
        "raw_samples_per_sec",
        "bytes_per_sample",
        "edge_reduction_ratio",
        "local_processing_latency_ms",
        "uplink_latency_ms",
        "power_budget_mw",
    ]

    missing = [col for col in required if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def compute_metrics(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["raw_bytes_per_sec"] = df["raw_samples_per_sec"] * df["bytes_per_sample"]
    df["processed_bytes_per_sec"] = df["raw_bytes_per_sec"] * (1 - df["edge_reduction_ratio"])
    df["bytes_saved_per_sec"] = df["raw_bytes_per_sec"] - df["processed_bytes_per_sec"]
    df["decision_time_ms"] = df["local_processing_latency_ms"] + df["uplink_latency_ms"]
    df["efficiency_score"] = df["bytes_saved_per_sec"] / df["power_budget_mw"]
    return df


def main() -> None:
    df = load_data(INPUT_FILE)
    results = compute_metrics(df)
    results.to_csv(OUTPUT_FILE, index=False)
    print("FPGA agricultural edge-pipeline modeling complete.")
    print(results.to_string(index=False))


if __name__ == "__main__":
    main()
