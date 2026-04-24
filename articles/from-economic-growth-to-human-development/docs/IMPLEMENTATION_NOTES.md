# Implementation Notes

This module is designed around five linked human-development questions:

1. Which settings show the largest gap between growth and real capability expansion?
2. Where are health, education, and agency improvements weakest relative to economic output?
3. Which territories show the strongest failures of public-goods conversion?
4. Where do distributional and institutional constraints most sharply weaken human development?
5. How can growth, capability, and durability be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python risk-scoring pipelines.
- Run R comparative and burden analysis.
- Use SQL tables and views to maintain human-development, governance, and burden registries.
- Use Go for lightweight human-development risk scoring integration.
