# Implementation Notes

This module is designed around five linked decent-work questions:

1. Which settings face the greatest labour fragility despite employment participation?
2. Where do informality and precarity most sharply weaken livelihood security?
3. Which territories show the strongest youth and gender exclusion from decent work?
4. Where are rights protection and social protection weakest relative to labour risk?
5. How can employment, security, and transition readiness be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python risk-scoring pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain work, governance, and burden registries.
- Use Go for lightweight labour-risk scoring integration.
