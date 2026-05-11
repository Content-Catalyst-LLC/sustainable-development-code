#!/usr/bin/env python3
import csv
import sqlite3
from pathlib import Path

ROOT = Path.cwd()
DB = ROOT / "outputs" / "future_development_dashboard.sqlite"
DATASETS = {
    "scenario_scores": ROOT / "data" / "future_development_scenarios.csv",
    "development_panel": ROOT / "data" / "development_viability_panel.csv",
    "policy_levers": ROOT / "data" / "policy_levers.csv",
}

DB.parent.mkdir(parents=True, exist_ok=True)
conn = sqlite3.connect(DB)
conn.executescript((ROOT / "sql" / "schema.sql").read_text(encoding="utf-8"))

for table, path in DATASETS.items():
    conn.execute(f"DELETE FROM {table}")
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        columns = reader.fieldnames or []
        placeholders = ",".join([f":{column}" for column in columns])
        column_sql = ",".join(columns)
        conn.executemany(
            f"INSERT INTO {table} ({column_sql}) VALUES ({placeholders})",
            reader,
        )

conn.commit()

print(f"SQLite development dashboard database written to {DB}")
print("Scenario dashboard preview:")
for row in conn.execute("""
    SELECT
        scenario,
        ROUND(
            0.16 * income_index +
            0.22 * ecological_integrity_index +
            0.18 * resilience_index +
            0.16 * governance_capacity_index +
            0.13 * technology_capability_index +
            0.15 * justice_equity_index,
            4
        ) AS viability_score,
        planetary_pressure_index,
        institutional_stress_index
    FROM scenario_scores
    ORDER BY viability_score DESC
"""):
    print(row)

conn.close()
