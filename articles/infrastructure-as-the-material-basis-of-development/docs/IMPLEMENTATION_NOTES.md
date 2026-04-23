# Implementation Notes

This module is designed around five linked infrastructure questions:

1. Which places have the strongest infrastructure access and service capability?
2. Where do maintenance, reliability, and climate resilience constrain development?
3. Which territories and groups face the highest infrastructure exclusion risk?
4. How does lock-in interact with resilience and future development pathways?
5. How can assets, maintenance, outages, and access be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python scoring pipelines.
- Run R comparative and exclusion analysis.
- Use SQL tables and views to maintain asset, maintenance, outage, and access registries.
- Use Go for lightweight readiness and resilience scoring integration.
