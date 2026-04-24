#!/usr/bin/env bash
set -euo pipefail

echo "Available governors:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors || true

echo
echo "Current governor:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor || true

echo
echo "Frequency time-in-state:"
cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state || true

echo
echo "Energy model files (if present):"
grep . /sys/devices/system/cpu/energy_model/* 2>/dev/null || true
