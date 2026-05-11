#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p outputs

echo "Running Python scenario stress test..."
python3 python/future_development_scenario_stress_test.py

echo "Running SQLite dashboard loader..."
python3 sql/run_sqlite_dashboard.py

if command -v Rscript >/dev/null 2>&1; then
  echo "Running R development viability panel summary..."
  Rscript r/development_viability_panel_summary.R
else
  echo "Skipping R workflow: Rscript not found"
fi

if command -v julia >/dev/null 2>&1; then
  echo "Running Julia threshold-loss model..."
  julia julia/threshold_loss_model.jl
else
  echo "Skipping Julia workflow: julia not found"
fi

echo "Done. Review generated files in outputs/."
