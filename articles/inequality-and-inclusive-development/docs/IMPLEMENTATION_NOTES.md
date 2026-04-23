# Implementation Notes

This module is designed around five linked inclusion questions:

1. Which settings face the greatest gap between average progress and broadly shared capability?
2. Where do public-goods deficits and opportunity blockage most sharply deepen exclusion?
3. Which territories show the strongest institutional concentration of advantage?
4. Where are governance and transition capacity weakest relative to inequality burden?
5. How can education, health, income security, and public-goods access be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python risk-scoring pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain inclusion, governance, and burden registries.
- Use Go for lightweight inclusion-risk scoring integration.
