# Setup Guide

## Python

From the repository root:

    python3 -m venv .venv
    source .venv/bin/activate
    pip install pandas numpy
    python articles/land-system-change-and-development-pathways/python/land_system_pathway_risk.py

## R

Install required packages if needed:

    install.packages(c("readr", "dplyr"))

Then run from the repository root:

    Rscript articles/land-system-change-and-development-pathways/r/territorial_exposure_analysis.R

## SQL

Use SQLite:

    sqlite3 land_system.db < articles/land-system-change-and-development-pathways/sql/land_system_schema.sql

## Rust

Compile and run:

    rustc articles/land-system-change-and-development-pathways/rust/land_pathway_score.rs -o land_pathway_score
    ./land_pathway_score
