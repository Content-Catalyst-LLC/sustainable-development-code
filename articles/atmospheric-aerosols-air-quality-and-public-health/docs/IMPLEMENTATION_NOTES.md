# Implementation Notes

This module is designed around five linked aerosol-burden questions:

1. Which settings face the highest ambient and household aerosol burdens?
2. Where do transport and industrial structures amplify exposure?
3. Which territories show the largest inequality in aerosol-health burden?
4. Where are monitoring and mitigation weakest relative to exposure?
5. How can exposure, vulnerability, and governance readiness be tracked together?

Suggested workflow:
- Validate raw CSVs with Rust.
- Run Python scoring pipelines.
- Run R comparative and inequality analysis.
- Use SQL tables and views to maintain exposure, source, and equity registries.
- Use Go for lightweight aerosol-burden scoring integration.
