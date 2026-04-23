# Implementation Notes

This module is designed around five linked mobility questions:

1. Which places have the strongest accessibility and opportunity reach?
2. Where do affordability, safety, and service reliability constrain spatial inclusion?
3. Which regions or groups face the highest transport exclusion risk?
4. How does car dependence interact with territorial inequality and climate alignment?
5. How can routes, fares, stops, and service performance be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python scoring pipelines.
- Run R comparative and exclusion analysis.
- Use SQL tables and views to maintain route, fare, stop, and service registries.
- Use Go for lightweight accessibility and travel-burden scoring integration.
