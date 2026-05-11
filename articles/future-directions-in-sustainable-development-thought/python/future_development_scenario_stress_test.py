#!/usr/bin/env python3
"""
Python Workflow: Scenario and Indicator Stress-Testing for Future Development Pathways
"""

from __future__ import annotations

import csv
import hashlib
import json
import platform
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"

WEIGHTS = {
    "income_index": 0.16,
    "ecological_integrity_index": 0.22,
    "resilience_index": 0.18,
    "governance_capacity_index": 0.16,
    "technology_capability_index": 0.13,
    "justice_equity_index": 0.15,
}

COMPONENTS = list(WEIGHTS.keys())


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def clamp(value: float, low: float = 0.0, high: float = 1.0) -> float:
    return max(low, min(high, value))


def viability_score(row: dict[str, str]) -> float:
    return sum(float(row[column]) * weight for column, weight in WEIGHTS.items())


def nonlinear_loss(pressure: float, threshold: float, lambda_loss: float) -> float:
    if pressure < threshold:
        return 0.0
    return lambda_loss * (pressure - threshold) ** 2


def classify(score: float) -> str:
    if score >= 0.75:
        return "high_viability"
    if score >= 0.55:
        return "medium_viability"
    return "high_concern"


def main() -> None:
    OUTPUTS.mkdir(exist_ok=True)
    scenarios_path = DATA / "future_development_scenarios.csv"
    levers_path = DATA / "policy_levers.csv"

    rows = read_csv(scenarios_path)
    levers = read_csv(levers_path)

    scored = []
    for row in rows:
        base_score = viability_score(row)
        ecological_loss = nonlinear_loss(float(row["planetary_pressure_index"]), 0.65, 1.40)
        institutional_loss = nonlinear_loss(float(row["institutional_stress_index"]), 0.70, 1.20)
        adjusted_score = clamp(base_score - ecological_loss - institutional_loss)

        minimum_component = min(float(row[column]) for column in COMPONENTS)
        weak_components = [
            column.replace("_index", "")
            for column in COMPONENTS
            if float(row[column]) < 0.50
        ]

        scored.append({
            "scenario": row["scenario"],
            "base_viability_score": round(base_score, 4),
            "ecological_threshold_loss": round(ecological_loss, 4),
            "institutional_threshold_loss": round(institutional_loss, 4),
            "adjusted_viability_score": round(adjusted_score, 4),
            "minimum_component_score": round(minimum_component, 4),
            "risk_classification": classify(adjusted_score),
            "weak_components": ";".join(weak_components) if weak_components else "none",
        })

    lever_results = []
    for row in rows:
        for lever in levers:
            simulated = dict(row)
            target = lever["target_dimension"]
            if target in simulated:
                simulated[target] = str(clamp(float(simulated[target]) + float(lever["expected_effect"])))
            base = viability_score(row)
            simulated_score = viability_score(simulated)
            lever_results.append({
                "scenario": row["scenario"],
                "lever_id": lever["lever_id"],
                "lever_name": lever["lever_name"],
                "target_dimension": target,
                "base_viability_score": round(base, 4),
                "simulated_viability_score": round(simulated_score, 4),
                "score_delta": round(simulated_score - base, 4),
                "implementation_horizon": lever["implementation_horizon"],
            })

    scored.sort(key=lambda item: item["adjusted_viability_score"], reverse=True)
    lever_results.sort(key=lambda item: item["score_delta"], reverse=True)

    write_csv(OUTPUTS / "future_development_viability_scores.csv", scored)
    write_csv(OUTPUTS / "policy_lever_simulation.csv", lever_results)

    manifest = {
        "run_id": str(uuid.uuid4()),
        "run_started_at_utc": datetime.now(timezone.utc).isoformat(),
        "article": "Future Directions in Sustainable Development Thought",
        "workflow": "scenario-and-indicator-stress-testing",
        "runtime": {"python": sys.version, "platform": platform.platform()},
        "inputs": {
            "future_development_scenarios": {
                "path": str(scenarios_path),
                "sha256": sha256_file(scenarios_path),
                "rows": len(rows),
            },
            "policy_levers": {
                "path": str(levers_path),
                "sha256": sha256_file(levers_path),
                "rows": len(levers),
            },
        },
        "weights": WEIGHTS,
    }

    (OUTPUTS / "scenario_stress_test_manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")

    print("Scenario stress test complete.")
    print(json.dumps({"scenarios": len(scored), "top_scenario": scored[0]}, indent=2))


if __name__ == "__main__":
    main()
