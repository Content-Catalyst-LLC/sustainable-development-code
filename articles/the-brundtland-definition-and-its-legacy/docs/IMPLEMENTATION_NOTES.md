# Implementation Notes

This module is designed around five linked Brundtland questions:

1. Which settings face the greatest tension between present need and future viability?
2. Where are ecological degradation and future-burden transfer most sharply weakening legitimacy?
3. Which territories show the strongest gaps in stewardship and institutional durability?
4. Where are absorptive-capacity stress and organisational constraints most likely to undermine sustainability?
5. How can need, stewardship, and long-run legitimacy be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python risk-scoring pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain Brundtland, governance, and burden registries.
- Use Go for lightweight Brundtland-legitimacy risk scoring integration.
