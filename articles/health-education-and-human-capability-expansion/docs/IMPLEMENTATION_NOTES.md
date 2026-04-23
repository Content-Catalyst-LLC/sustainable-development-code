# Implementation Notes

This module is designed around five linked capability questions:

1. Which settings face the greatest gap between formal access and real human capability?
2. Where do health and education quality deficits most sharply narrow development?
3. Which territories show the strongest interaction between financial hardship and learning deprivation?
4. Where are governance and transition capacity weakest relative to capability loss?
5. How can health, education, service quality, and inclusion be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python risk-scoring pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain capability, governance, and burden registries.
- Use Go for lightweight capability-risk scoring integration.
