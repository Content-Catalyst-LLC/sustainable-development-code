# Implementation Notes

This module is designed around five linked indicator-governance questions:

1. Which settings show the largest gap between headline attainment and hidden deprivation?
2. Where do inequality, gender gaps, and multidimensional poverty most sharply weaken headline indicators?
3. Which territories show the strongest subnational variation hidden by averages?
4. Where are coverage and data-quality constraints strongest?
5. How can measurement, interpretation, and governance readiness be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python diagnostic pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain indicator, methodology, and burden registries.
- Use Go for lightweight indicator-risk scoring integration.
