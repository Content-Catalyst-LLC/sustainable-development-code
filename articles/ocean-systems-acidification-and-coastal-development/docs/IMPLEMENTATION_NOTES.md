# Implementation Notes

This module is designed around five linked coastal-ocean questions:

1. Which coastal systems face the greatest acidification and marine-habitability stress?
2. Where do dependence on fisheries, marine ecosystems, and coastal infrastructure amplify risk?
3. Which coasts show the strongest inequality in exposure and weakest adaptive capacity?
4. Where are monitoring and governance weakest relative to ocean change?
5. How can acidification, dependence, justice exposure, and readiness be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python scoring pipelines.
- Run R comparative and exposure analysis.
- Use SQL tables and views to maintain coastal, dependence, and governance registries.
- Use Go for lightweight coastal-ocean risk scoring integration.
