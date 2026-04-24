# Implementation Notes

This module is designed around five linked overshoot questions:

1. Which settings face the greatest mismatch between growth pressure and support conditions?
2. Where are throughput and planetary pressure most strongly eroding long-run viability?
3. Which territories show the strongest risks of late recognition and lock-in?
4. Where are governance fragility and adaptive weakness most likely to amplify overshoot?
5. How can throughput, delay, and viability be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python risk-scoring pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain overshoot, governance, and burden registries.
- Use Go for lightweight overshoot-risk scoring integration.
