# How Sustainable Development Is Measured

This module contains the code workflows referenced in the article on how sustainable development is measured.

## Included workflows

- Python: indicator normalization, distance-to-target scoring, composite summaries, and coverage audits
- R: disaggregation, subgroup-gap analysis, and reporting visibility diagnostics
- SQL: indicator registry, metadata versioning, and dashboard views
- Rust: validation utility for indicator input records
- Go: lightweight scoring service for SDG-style indicators
- Embedded C: optional low-resource data collection / reporting stub
- C++: optional edge-side data quality and completeness scoring

## Folder layout

- `python/`: normalization, scoring, coverage, and diagnostics
- `r/`: disaggregation and subgroup reporting analysis
- `sql/`: schema, metadata logs, and dashboard views
- `rust/`: typed validation tooling
- `go/`: lightweight scoring service
- `c/`: optional embedded reporting logic
- `cpp/`: optional edge data-quality scoring
- `data/raw/`: source datasets
- `data/processed/`: generated outputs
- `outputs/`: notes and exported artifacts
