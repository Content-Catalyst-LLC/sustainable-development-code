# Setup Guide

## Python

From the repository root:

    python3 -m venv .venv
    source .venv/bin/activate
    pip install pandas numpy
    python articles/freshwater-change-and-development-risk/python/freshwater_change_risk.py

## R

Install required packages if needed:

    install.packages(c("readr", "dplyr"))

Then run from the repository root:

    Rscript articles/freshwater-change-and-development-risk/r/hydrological_exposure_analysis.R

## SQL

Use SQLite:

    sqlite3 freshwater_change.db < articles/freshwater-change-and-development-risk/sql/freshwater_change_schema.sql

## Rust

Compile and run:

    rustc articles/freshwater-change-and-development-risk/rust/freshwater_risk_score.rs -o freshwater_risk_score
    ./freshwater_risk_score
